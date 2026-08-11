
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>

static void run(const char *fmt, ...) {
    char cmd[1024];
    va_list args;
    va_start(args, fmt);
    vsnprintf(cmd, sizeof(cmd), fmt, args);
    va_end(args);
    if (system(cmd) != 0) {
        fprintf(stderr, "Error running: %s\n", cmd);
    }
}

static char *capture(const char *fmt, ...) {
    char cmd[1024];
    va_list args;
    va_start(args, fmt);
    vsnprintf(cmd, sizeof(cmd), fmt, args);
    va_end(args);
    FILE *fp = popen(cmd, "r");
    if (!fp) return NULL;
    char buf[128];
    if (!fgets(buf, sizeof(buf), fp)) {
        pclose(fp);
        return NULL;
    }
    pclose(fp);
    buf[strcspn(buf, "\r\n")] = '\0';
    return strdup(buf);
}

int main() {
    // Check if we are already inside a tmux session
    char *tmux_env = getenv("TMUX");

    // Determine the current user's shell
    char *shell = getenv("SHELL");
    if (shell == NULL || shell[0] == '\0') {
        shell = "/bin/bash";
    }

    if (tmux_env == NULL) {
        // SCENARIO 1: No tmux active -> Start a new session
        printf("[*] No active tmux session. Starting new session...\n");
        execlp("tmux", "tmux", "new-session", NULL);

        // If execlp fails
        perror("Failed to start tmux");
        return 1;
    }

    // SCENARIO 2: Already inside tmux -> Build the 3-pane layout
    printf("[*] Active tmux detected. Building layout...\n");

    // Current pane becomes the top-left (shell) pane
    char *left = capture("tmux display-message -p '#{pane_id}'");
    if (!left) {
        fprintf(stderr, "Error resolving current pane.\n");
        return 1;
    }

    // 1. Split horizontally to create a thin bottom pane running the user shell
    char *bottom = capture("tmux split-window -v -l 6 -P -F '#{pane_id}' \"exec %s\"", shell);
    if (!bottom) {
        fprintf(stderr, "Error creating horizontal split.\n");
        free(left);
        return 1;
    }

    // 2. Split the top pane vertically: right pane runs opencode
    char *right = capture("tmux split-window -h -t %s -P -F '#{pane_id}' 'opencode; exec %s'", left, shell);
    if (!right) {
        fprintf(stderr, "Error creating vertical split.\n");
        free(left);
        free(bottom);
        return 1;
    }

    // 3. Disable passthrough on the opencode pane to stop OSC escape sequence leakage
    run("tmux set-option -t %s -p allow-passthrough off", right);

    // 4. Move focus back to the left pane (top-left, user shell)
    run("tmux select-pane -t %s", left);

    free(left);
    free(bottom);
    free(right);
    return 0;
}
