# pmc

Poor Mans CA is a small bash script to get a local CA up and running, quickly.

Used in testing mTLS solutions

## usage

There are two major features. Creating a CA, and adding client certificates quickly.

### makeca

Run the script with the `makeca` subcommand, fill in the questions, and have a CA configured in the `ca/` directory.

```bash
$ ./pmc.sh makeca

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
Country Name (2 letter code) [AU]:gb
State or Province Name (full name) [Some-State]:someprov
Locality Name (eg, city) []:somecity
Organization Name (eg, company) [Internet Widgits Pty Ltd]:someorg
Organizational Unit Name (eg, section) []:someou
Common Name (e.g. server FQDN or YOUR name) []:test.local
Email Address []:it@test.local
i| generating pem @ ca/ca.pem
i| generating pkcs#12 @ ca/ca.p12. get ready to enter a password to protect it
Enter Export Password:
Verifying - Enter Export Password:
i| done
```

### add

Add a new client with the `add` subcommand.

```bash
$ ./pmc.sh add leon

    -- poor mans ca --

i| using ca certificate @ ca/ca.crt
i| ca certificate subject: subject=C=gb, ST=someprov, L=somecity, O=someorg, OU=someou, CN=test.local, emailAddress=it@test.local
i| generating client key @ ca/user1/user1.key...
i| generating csr @ ca/user1/user1.csr
i| generating csr for subject: /C=gb/ST=someprov/L=somecity/O=someorg/OU=someou/CN=user1.test.local
i| generating crt @ ca/user1/user1.crt
Certificate request self-signature ok
subject=C=gb, ST=someprov, L=somecity, O=someorg, OU=someou, CN=user1.test.local
i| generating pem @ ca/user1/user1.pem
i| generating pkcs#12 @ ca/user1/user1.p12. get ready to enter a password to protect it
Enter Export Password:
Verifying - Enter Export Password:
i| done
```
