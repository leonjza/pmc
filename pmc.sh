#!/bin/bash

# 2024, @leonjza

set -e

echo
echo "	-- poor mans ca --"
echo

ca_dir=ca
ca_key_file_path=$ca_dir/ca.key
ca_x509_cert_path=$ca_dir/ca.crt
ca_x509_pem_path=$ca_dir/ca.pem
ca_x509_p12_path=$ca_dir/ca.p12

function make_ca() {

	# check if ca directory already exists
	if [[ -d $ca_dir ]]; then
		echo "e| ca directory $ca_dir already exists"
		return 1
	else
		mkdir -p $ca_dir
	fi

	if [[ -f "$ca_key_file_path" ]]; then
		echo "e| ca key file path already exists"
		return 1
	fi

	echo "i| generating private key @ $ca_key_file_path"
	openssl genrsa \
		-out $ca_key_file_path 4096

	echo "i| creating x509 certificate @ $ca_x509_cert_path. get ready to answer some questions!"
	openssl req -x509 -new -nodes \
		-key $ca_key_file_path \
		-sha256 -days 1024 \
		-out $ca_x509_cert_path

	echo "i| generating pem @ $ca_x509_pem_path"
	cat $ca_x509_cert_path $ca_key_file_path > $ca_x509_pem_path

	echo "i| generating pkcs#12 @ $ca_x509_p12_path. get ready to enter a password to protect it"
	openssl pkcs12 -export \
		-out $ca_x509_p12_path \
		-inkey $ca_key_file_path \
		-in $ca_x509_cert_path \
		-certfile $ca_x509_cert_path

	echo "i| done"
}

function add_client() {
	local client_name="$1"

	echo "i| using ca certificate @ $ca_x509_cert_path"
	echo "i| ca certificate subject: $(openssl x509 -in $ca_x509_cert_path -noout -subject)"

	client_dir=$ca_dir/$client_name
	client_key_path=$client_dir/$client_name.key
	client_csr_path=$client_dir/$client_name.csr
	client_crt_path=$client_dir/$client_name.crt
	client_pem_path=$client_dir/$client_name.pem
	client_p12_path=$client_dir/$client_name.p12

	if [[ -d $client_dir ]]; then
		echo "e| client directory $client_dir already exists"
		return 1
	else
		mkdir -p $client_dir
	fi

	echo "i| generating client key @ $client_key_path..."
	openssl genrsa \
		-out $client_key_path 2048

	existing_subject=$(openssl x509 \
		-in $ca_x509_cert_path -noout -subject | \
		sed \
			-e 's/^subject=//' \
			-e 's/^[ \t]*//' \
			-e 's|, emailAddress=[^/]*||' \
	)
	new_subject="/"$(echo "$existing_subject" | \
		sed -r "s/(CN=)([^,]+)/\1${client_name}.\2/" | \
		sed -e 's/, /\//g' \
	)

	echo "i| generating csr @ $client_csr_path"
	echo "i| generating csr for subject: $new_subject"
	openssl req -new -sha256 -key $client_key_path \
		-subj $new_subject \
		-out $client_csr_path

	echo "i| generating crt @ $client_crt_path"
	openssl x509 -req -in $client_csr_path \
		-CA $ca_x509_cert_path -CAkey $ca_key_file_path \
		-CAcreateserial -out $client_crt_path \
		-days 365 -sha256

	echo "i| generating pem @ $client_pem_path"
	cat $client_crt_path $client_key_path > $client_pem_path

	echo "i| generating pkcs#12 @ $client_p12_path. get ready to enter a password to protect it"
	openssl pkcs12 -export \
		-out $client_p12_path \
		-inkey $client_key_path \
		-in $client_crt_path \
		-certfile $ca_x509_cert_path

	echo "i| done"
}

if [ $# -eq 0 ]; then
    echo "No arguments provided. Exiting."
    exit 1
fi

case "$1" in
	makeca)
		make_ca
		;;
	add)
		if [ $# -lt 2 ]; then
            echo "Subcommand 'add' requires a name argument"
            exit 1
        fi
		add_client "$2"
		;;
	*)
		echo "Unknown command: $1"
		exit 1
		;;
esac
