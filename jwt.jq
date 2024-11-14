module {
  homepage: "github.com/robzr",
  name: "jwt",
  version: "0.0.1",
};

def url_safe_decode:
  gsub("_"; "/")
  | gsub("-"; "+")
  ;

def url_safe_encode:
  gsub("/"; "_")
  | gsub("\\+"; "-")
  | gsub("="; "")
  | gsub("\n"; "")
  ;

def url_safe_base64_decode:
  url_safe_decode
  | @base64d
  ;

def url_safe_base64_encode:
  @base64
  | url_safe_encode
  ;

def validate:
  (split(".") | length) as $jwt_fields
  | if $jwt_fields != 3 then
      "Invalid jwt - contains \($jwt_fields) fields, requires 3."
      | error
    else
      .
    end
  ;

def decode_raw:
  validate
  | {
    headers: (split(".")[0] | url_safe_base64_decode | fromjson),
    payload: (split(".")[1] | url_safe_base64_decode | fromjson),
    unsigned: (split(".")[0] + "." + split(".")[1]),
    signature: (split(".")[2] | url_safe_decode),
  }
  ;

def verify($signature):
  . as $jwt
  | decode_raw 
  | . * {
    algorithm: (.headers.alg),
    jwt: $jwt,
    verified: (($signature | @base64d) == (.signature | @base64d)),
  }
  | to_entries
  | sort_by(.key)
  | from_entries
  ;
