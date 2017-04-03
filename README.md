# pacebyelm
*Because sometimes you need to sooth those sore JavaScript muscles with a little Elm byelm*

Example front-end for Runby Pace (https://runbypace.com) written in Elm

# Installing prerequisites
To play with pacebyelm, you'll need to install `elm` and `json-server` with `npm`. I also recommend `elm-live`.

## Install `npm`
`npm` (**N**ode **P**ackage **M**anager) is a package manager comes with Node.js

https://docs.npmjs.com/getting-started/installing-node

## Install Elm
Once you have npm installed, use it to install Elm

https://guide.elm-lang.org/install.html

     npm install -g elm
     npm install -g elm-live
     
## Install json-server
`json-server` is a fake REST API.

https://github.com/typicode/json-server

     npm install -g json server
     
# Running pacebyelm
 1. Clone or download this repo
 
    `git clone git@github.com:tygerbytes/pacebyelm.git`
     
 
 2. Enter the `pacebyelm` directory
 
    `cd pacebyelm`
     
 
 2. Start the `json-server`
  
    `json-server json-server/db.json`
     
     
Note that `db.json` only has a few entries at present. You'll only be able to look up paces for 5K race times of "20:00". (Hopefully that sentence makes sense once you see the interface and look at the contents of `db.json`.) 

At first I was going to use the api of https://runbypace.com, but I accidentally broke it when I switched on SSL and haven't had the time or need to fix it. Meanwhile `json-server` fills the need nicely.

3. Start `elm-live`

     `elm-live Pacebyelm.elm --open --debug --output=pacebyelm.js`
     
That command will automatically launch your default browswer and navigate to `http://localhost:8000`. 

4. Play around with Elm! :)
