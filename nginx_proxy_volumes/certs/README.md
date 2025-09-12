# certs

## dhparam.pem

You need to generate a Diffie-Hellman Parameters file before initiating the containers.
 
```
openssl dhparam -out dhparam.pem 4096
chmod 644 dhparam.pem
```

## Migrate existing certs from let's encrypt certbot's tree

If there is just one account creted in the `accounts` subdirectory you can use wildcard `*`, else you will have to specify the full id i.e. `ACCOUNT=2b69e2a7428fda29c50b7bacc3236812`.

```
DOMAIN=example.com
BASEDIR=/etc/letsencrypt
ACCOUNT=*
SERVER=acme-v01.api.letsencrypt.org

ACCDIR=$BASEDIR/accounts/$SERVER/directory/"$ACCOUNT"
CRTDIR=$BASEDIR/live/$DOMAIN		

mkdir $DOMAIN
cp $ACCDIR/private_key.json $DOMAIN/account_key.json
cp $CRTDIR/cert.pem $DOMAIN/cert.pem
cp $CRTDIR/chain.pem $DOMAIN/chain.pem
cp $CRTDIR/fullchain.pem $DOMAIN/fullchain.pem
cp $CRTDIR/privkey.pem $DOMAIN/key.pem
chmod 644 $DOMAIN/*
ln -s $DOMAIN/chain.pem $DOMAIN.chain.pem
ln -s $DOMAIN/fullchain.pem $DOMAIN.crt
ln -s $DOMAIN/key.pem $DOMAIN.key
ln -s dhparam.pem $DOMAIN.dhparam.pem
```

