# Setup ``dropbear`` server

## Sample directory structure:

```
/boot/ssh/
├── authorized_keys
│   └── root
├── host.key
└── host.pem
```

## Dropbear config directory

```
/etc/dropbear/
└── host.key
```

``host.key`` file will be generated as required.
It can be converted from a PEM file (``host.pem``).
Files found in ``/boot/ssh/authorized_keys`` will be copied,
to the corresponding users ``.ssh`` directories.

## Generate ``host.pem`` file

```sh
yes | ssh-keygen -m PEM -t rsa -b 4096 -N '' -f host.pem
```

```sh
yes | ssh-keygen -m PEM -t ecdsa -b 521 -N '' -f host.pem
```

## See also

* [What is RSA, DSA and ECC?][what-is-rsa-dsa-ecc]
* [Choosing an Algorithm and Key Size][choosing-an-algorithm-and-key-size]

<!-- hyperlinks -->

[what-is-rsa-dsa-ecc]: https://www.ssl247.com/kb/ssl-certificates/generalinformation/what-is-rsa-dsa-ecc
[choosing-an-algorithm-and-key-size]: https://www.ssh.com/ssh/keygen#choosing-an-algorithm-and-key-size
