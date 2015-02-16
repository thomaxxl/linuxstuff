#!/bin/bash
#
# Generate a CA and signed server cert
#
#
cat > openssl-ca.cnf << EOF
HOME            = .
RANDFILE        = .rnd
[ ca ]
default_ca  = CA_default        # The default ca section
[ usr_cert ]
basicConstraints = CA:false
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer

[ CA_default ]

default_days    = 1000          # how long to certify for
default_crl_days= 30            # how long before next CRL
default_md  = sha256        # use public key default MD
preserve    = no            # keep passed DN ordering

x509_extensions = ca_extensions     # The extensions to add to the cert

email_in_dn = no            # Don't concat the email in the DN
copy_extensions = copy          # Required to copy SANs from CSR to cert

certificate = cacert.pem  # The CA certifcate
private_key = cakey.pem   # The CA private key
new_certs_dir   = .     # Location for new certs after signing
database    = index.txt   # Database index file
serial      = serial.txt  # The current serial number

unique_subject  = no            # Set to 'no' to allow creation of
                                # several certificates with same subject.

[ req ]
default_bits        = 4096
default_keyfile     = cakey.pem
distinguished_name  = ca_distinguished_name
x509_extensions     = ca_extensions
string_mask         = utf8only

[ ca_distinguished_name ]
countryName         = Country Name (2 letter code)
countryName_default     = BE

stateOrProvinceName     = State or Province Name (full name)
stateOrProvinceName_default = A

localityName            = Locality Name (eg, city)
localityName_default        = Wommelgem

organizationName         = Organization Name (eg, company)
organizationName_default    = SecureLink

commonName          = Common Name (e.g. server FQDN or YOUR name)
commonName_default      = SecureLink MSS CA

emailAddress            = Email Address
emailAddress_default        = thomas.pollet@securelink.be

[ ca_extensions ]

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always, issuer
basicConstraints = critical, CA:true
keyUsage = keyCertSign, cRLSign

[ policy_anything ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional
EOF


cat > openssl-server.cnf << EOF
HOME            = .
RANDFILE        = .rnd

[ req ]
default_bits        = 2048
default_keyfile     = serverkey.pem
distinguished_name  = server_distinguished_name
req_extensions      = server_req_extensions
string_mask         = utf8only

[ server_distinguished_name ]
countryName         = Country Name (2 letter code)
countryName_default     = BE

stateOrProvinceName     = State or Province Name (full name)
stateOrProvinceName_default = A

localityName            = Locality Name (eg, city)
localityName_default        = Wommelgem

rganizationName         = Organization Name (eg, company)
organizationName_default    = SecureLink MSS CA

commonName          = Common Name (e.g. server FQDN or YOUR name)
commonName_default      = mss.securelink.eu

emailAddress            = Email Address
emailAddress_default        = mss@securelink.eu

[ server_req_extensions ]

subjectKeyIdentifier        = hash
basicConstraints        = CA:FALSE
keyUsage            = digitalSignature, keyEncipherment
subjectAltName          = @alternate_names
nsComment           = "OpenSSL Generated Certificate"

[ alternate_names ]

DNS.1       = example.com


EOF

# Generate ca cert
(while true; do echo ; done ) | openssl req -x509 -config openssl-ca.cnf -newkey rsa:4096 -sha256 -nodes -out cacert.pem -outform PEM

# Generate server cert
(while true; do echo ; done ) | openssl req -config openssl-server.cnf -newkey rsa:2048 -sha256 -nodes -out servercert.csr -outform PEM

# View:
openssl req -text -noout -verify -in servercert.csr

# CSR: 
(while true; do echo ; done ) | openssl req -config openssl-server.cnf -newkey rsa:2048 -sha256 -nodes -out servercert.csr -outform PEM

openssl req -text -noout -verify -in servercert.csr

> index.txt
echo 01 > serial.txt

# Sign CSR
(while true; do echo y; done )  | openssl ca -keyfile cakey.pem -cert cacert.pem -extensions usr_cert -notext -md sha256 -in servercert.csr -out servercert.pem -config openssl-ca.cnf  -policy policy_anything

