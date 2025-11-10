#include <openssl/evp.h>
#include <string.h>

void SHA1_Digest(const void *data, size_t len, unsigned char *digest) {
    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    if (!ctx) return;

    EVP_DigestInit_ex(ctx, EVP_sha1(), NULL);
    EVP_DigestUpdate(ctx, data, len);
    EVP_DigestFinal_ex(ctx, digest, NULL);
    EVP_MD_CTX_free(ctx);
}
