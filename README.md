# README #

## How do I get set up? 

### node 
`sudo apt get install node-js`
`sudo ln -s node-js /usr/bin/node`

### grunt, bower

`npm install -g grunt`
`npm install -g bower`

You will probably need to chown back to you owner of the `~/.npm`

## Contribution guidelines

Specidy api endpoint in `config.coffee` (use `http://localhost:8080` for default develepment app engine configuration)

## Run

* (api)[https://bitbucket.org/nkdhny/the-plate] `dev_appserver.py ./api`
* client (this project) `grunt serve`