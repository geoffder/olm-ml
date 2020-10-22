#include "olm/account.hh"
#include "fuzzing.hh"

int main(int argc, const char *argv[]) {
    int pickle_fd = STDIN_FILENO;
    uint8_t * pickle_buffer;
    ssize_t pickle_length = check_errno(
        "Error reading pickle file", read_file(pickle_fd, &pickle_buffer)
    );
    olm::Account * account = new olm::Account;
    unpickle(pickle_buffer, pickle_buffer + pickle_length, *account);
    free(pickle_buffer);
    delete account;
}
