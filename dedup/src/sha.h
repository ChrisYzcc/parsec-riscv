/*
 * Proxy SHA1 header file for PARSEC Benchmark Suite
 * Updated for OpenSSL 1.1+ by Yang Zechen
 */

#ifndef _SHA_H_
#define _SHA_H_

#include <openssl/sha.h>

/* SHA1 length is 20 bytes (160 bits) */
#define SHA1_LEN  20

#ifdef __cplusplus
extern "C" {
#endif

void SHA1_Digest(const void *data, size_t len, unsigned char *digest);

#ifdef __cplusplus
}
#endif

#endif //_SHA_H_
