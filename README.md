# pmc

Poor Mans CA is a small bash script to get a local CA up and running, quickly.

Used in testing mTLS solutions

## usage

There are two major features. Creating a CA, and adding client certificates quickly.

### makeca

Run the script with the `makeca` subcommand, fill in the questions, and have a CA configured in the `ca/` directory.

```bash
$ ./ca.sh makeca

	-- poor mans ca --

i| generating private key @ ca/ca.key
i| creating x509 certificate @ ca/ca.crt. get ready to answer some questions!
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ZA
State or Province Name (full name) [Some-State]:PewVille
Locality Name (eg, city) []:PewPew
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:pew.local
Email Address []:
```

### add

Add a new client with the `add` subcommand.

```bash
$ ./ca.sh add leon

	-- poor mans ca --

i| using ca certificate @ ca/ca.crt
i| generating client key @ ca/leon/leon.key...
i| generating csr @ ca/leon/leon.csr
i| generating crt @ ca/leon/leon.crt
Certificate request self-signature ok
i| generating pem @ ca/leon/leon.pem
i| done
```

