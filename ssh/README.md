# Setup ``dropbear`` server

## Sample directory structure:

```
/boot/ssh/
├── authorized_keys
│   └── root
├── host_rsa
└── host_rsa.pem
```

## Dropbear config directory

```
/etc/dropbear/
└── host_rsa
```

``host_rsa`` file will be generated as required.
It can be converted from a PEM file (``host_rsa.pem``).
Files found in ``/boot/ssh/authorized_keys`` will be copied,
to the corresponding users ``.ssh`` directories.

## Generate ``host_rsa.pem`` file

```sh
yes | ssh-keygen -t rsa -b 4096 -N '' -f host_rsa.pem -m PEM -C "your_email@example.com"
```
