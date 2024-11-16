# jwt
GitHub Action to Decode, Encode, Sign & Verify RFC-7519 compliant JSON Web
Tokens (JWTs) with options including masking, JSON object dump & more.

# Usage
## Decoding
To decode & verify an existing token, pass it via the `jwt` input parameter.
```
    - name: JSON Web Token (JWT)
      uses: direct-actions/jwt@v1
      with:
        enable-display: true
        jwt: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```
Setting `enable-display: true` will display a dump of the token fields, metadata,
and status of verification.

## Encoding
To encode a token, simply pass the payload in either YAML or JSON format - it
will be converted to compact/minify'd JSON before being encoded.
```
    - name: JSON Web Token (JWT)
      id: jwt
      uses: direct-actions/jwt@v1
      with:
        enable-display: true
        payload: |
          sub: '1234567890'
          name: John Doe
          iat: 1516239022
        secret: 'your-256-bit-secret'
```
The JWT is accessible via the `jwt` output (ex: `steps.jwt.outputs.jwt`).

## Masking
GitHub Actions seems to have hardcoded in masking of any string beginning with
the default/most common HS256 JWT header (`eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9`).
To dump a JWT to the Actions console, I simply base64 them,
(`echo '${{ steps.jwt-encode.outputs.jwt }}' | openssl base64 -e -A`), or you
can override the default header and insert a bogus key/value at the beginning:
```
    header: |
      abc: def
      alg: ${ALGORITHM}
      typ: JWT
```
To force masking, use the `enable-mask-jwt: true` input.

# Limitations / TODO
- Currently, this action only supports the common HS256 symmetric key signing
 cipher. I would like to add public key signing, but there is no roadmap.
- Even when `enable-mask-signature` is enabled, the Base64 (non-url-safe)
 version of the signature is not masked. Will fix.
