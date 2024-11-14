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

def jwt_regex:
  "^(?<header>[0-9A-Za-z_-]+)\\.(?<payload>[0-9A-Za-z_-]+)\\.(?<signature>[0-9A-Za-z_-]+)$"
  ;

def validate:
  test(jwt_regex; "")
  ;

def decode_raw:
  if validate | not then
    "Invalid JWT, does not match pattern." | error
  else
    capture(jwt_regex; "")
    | {
      header: (.header),
      payload: (.payload | url_safe_base64_decode | fromjson),
      unsigned: "\(.header).\(.payload)",
      signature: (.signature | url_safe_decode),
    }
  end
  ;

def verify($signature):
  . as $jwt
  | decode_raw
  | . * {
    algorithm: (.header.alg),
    jwt: $jwt,
    verified: (($signature | @base64d) == (.signature | @base64d)),
  }
  | to_entries
  | sort_by(.key)
  | from_entries
  ;
