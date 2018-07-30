# Setup ``dropbear`` server

Sample config directory structure:

```
/etc/dropbear/
├── allow
│   └── root
├── host_rsa
└── host_rsa.pem
```

``host_rsa`` file SHOULD be mounted, or it will be generated
it can be converted from a PEM file (``host_rsa.pem``).
Files found in ``/etc/dropbear/allow`` will be copied,
to the corresponding users ``.ssh`` directories.

## Generate ``host_rsa.pem`` file

```sh
yes | ssh-keygen -t rsa -b 4096 -N '' -f host_rsa.pem -m PEM -C "your_email@example.com"
```
