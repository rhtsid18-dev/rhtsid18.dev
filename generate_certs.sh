#!/bin/bash

# Deleting the ./certs directory if it pre exists
rm -rf ./certs

# Create a directory called 'certs'
mkdir -p certs

# Generate RSA private key for the CA and save it in the 'certs' directory
openssl genrsa -des3 -out ./certs/local.rhtsid18.dev.CA.key 2048

# Generate a self-signed certificate using the CA private key
openssl req -x509 -new -nodes -key ./certs/local.rhtsid18.dev.CA.key -sha256 -days 1825 -out ./certs/local.rhtsid18.dev.CA.pem

echo "CA RSA private key and self-signed certificate generated and saved in 'certs' directory."

# Check the operating system and add the CA certificate as a trusted root CA accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if [[ -f /usr/local/share/ca-certificates/local.rhtsid18.dev.CA.pem ]]; then
        sudo rm /usr/local/share/ca-certificates/local.rhtsid18.dev.CA.pem
    fi
    sudo cp ./certs/local.rhtsid18.dev.CA.pem /usr/local/share/ca-certificates/
    sudo update-ca-certificates
    echo "CA Certificate added as a trusted root CA on Linux."
    # Add domain to /etc/hosts
    echo "127.0.0.1 local.rhtsid18.dev" | sudo tee -a /etc/hosts
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [[ -n "$(security find-certificate -c 'local.rhtsid18.dev.CA' -a -Z)" ]]; then
        security delete-certificate -c 'local.rhtsid18.dev.CA'
    fi
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./certs/local.rhtsid18.dev.CA.pem
    echo "CA Certificate added as a trusted root CA on macOS."
    # Add domain to /etc/hosts
    echo "127.0.0.1 local.rhtsid18.dev" | sudo tee -a /etc/hosts
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash or Windows Subsystem for Linux)
    echo "Please manually add the CA certificate as a trusted root CA on Windows."
    echo "Please manually add the following line to your hosts file:"
    echo "127.0.0.1 local.rhtsid18.dev"
else
    echo "Unsupported operating system."
fi

# Generate RSA private key for the domain and save it in the 'certs' directory
openssl genrsa -out ./certs/local.rhtsid18.dev.key 2048

echo "Domain RSA private key generated and saved in 'certs' directory."

# Generate a Certificate Signing Request (CSR) using the domain private key
openssl req -new -key ./certs/local.rhtsid18.dev.key -out ./certs/local.rhtsid18.dev.csr

echo "Certificate Signing Request (CSR) generated and saved in 'certs' directory."

# Create the local.rhtsid18.dev.ext file with specified content
echo "authorityKeyIdentifier=keyid,issuer" > ./certs/local.rhtsid18.dev.ext
echo "basicConstraints=CA:FALSE" >> ./certs/local.rhtsid18.dev.ext
echo "keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment" >> ./certs/local.rhtsid18.dev.ext
echo "subjectAltName = @alt_names" >> ./certs/local.rhtsid18.dev.ext
echo "[alt_names]" >> ./certs/local.rhtsid18.dev.ext
echo "DNS.1 = local.rhtsid18.dev" >> ./certs/local.rhtsid18.dev.ext

echo "Certificate configuration file 'local.rhtsid18.dev.ext' created in 'certs' directory."

# Generate the certificate using the CSR and configuration file
openssl x509 -req -in ./certs/local.rhtsid18.dev.csr -CA ./certs/local.rhtsid18.dev.CA.pem -CAkey ./certs/local.rhtsid18.dev.CA.key -CAcreateserial -out ./certs/local.rhtsid18.dev.crt -days 825 -sha256 -extfile ./certs/local.rhtsid18.dev.ext

echo "Certificate generated and saved in 'certs' directory."
