#include "olm/olm.hh"

#include "fuzzing.hh"

int main(int argc, const char *argv[]) {
    size_t ignored;
    if (argc <= 2) {
        const char * message = "Usage: decrypt <pickle_key> <group_session>\n";
        ignored = write(STDERR_FILENO, message, strlen(message));
        exit(3);
    }

    const char * key = argv[1];
    size_t key_length = strlen(key);


    int session_fd = check_errno(
        "Error opening session file", open(argv[2], O_RDONLY)
    );

    uint8_t *session_buffer;
    ssize_t session_length = check_errno(
        "Error reading session file", read_file(session_fd, &session_buffer)
    );

    int message_fd = STDIN_FILENO;
    uint8_t * message_buffer;
    ssize_t message_length = check_errno(
        "Error reading message file", read_file(message_fd, &message_buffer)
    );

    uint8_t * tmp_buffer = (uint8_t *) malloc(message_length);
    memcpy(tmp_buffer, message_buffer, message_length);

    uint8_t session_memory[olm_inbound_group_session_size()];
    OlmInboundGroupSession * session = olm_inbound_group_session(session_memory);
    check_error(
        olm_inbound_group_session_last_error,
        session,
        "Error unpickling session",
        olm_unpickle_inbound_group_session(
            session, key, key_length, session_buffer, session_length
        )
    );

    size_t max_length = check_error(
        olm_inbound_group_session_last_error,
        session,
        "Error getting plaintext length",
        olm_group_decrypt_max_plaintext_length(
            session, tmp_buffer, message_length
        )
    );

    uint8_t plaintext[max_length];

    uint32_t ratchet_index;

    size_t length = check_error(
        olm_inbound_group_session_last_error,
        session,
        "Error decrypting message",
        olm_group_decrypt(
            session,
            message_buffer, message_length,
            plaintext, max_length, &ratchet_index
        )
    );

    ignored = write(STDOUT_FILENO, plaintext, length);
    ignored = write(STDOUT_FILENO, "\n", 1);
    return ignored;
}
