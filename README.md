# jwt
GitHub Action to Decode, Encode, Sign & Verify JSON Web Tokens (JWTs) with
options including masking, JSON object dump & more.

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
