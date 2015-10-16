Assist Network -- Backend Servce
================================

[![Build Status](https://travis-ci.org/AssistNetwork/an-backend.svg)](https://travis-ci.org/AssistNetwork/an-backend)
[![Coverage Status](https://coveralls.io/repos/AssistNetwork/an-backend/badge.svg?branch=master&service=github)](https://coveralls.io/github/AssistNetwork/an-backend?branch=master)

This is.

There is a lot to do.

0. megfelelő config file-ok: Gemfile, .gemspec, .travis.yml, ...
1. local dev and travis-ci test sample with minitest 
2. backend authorization https://intridea.github.io/grape/docs/Grape/Middleware/Auth/OAuth2.html ???
3. api functional testing
4. api non functional testing
5. 


Endpoints

api/com
api/object
api/flow

and will come
api/auth
api/admin/node
api/admin/network

Commands
'd', 's', 'o', 'g' => demand, supply, offer, get ...

Assist Network COM packet

COM packet structure:  Who ( network+node ), What ( cmd, what ), When ( start, end ), Where (where)

{
  "network": "an",
  "node":"1",
  "msg":  [
            {
              "cmd": "d",
              "content": {
                "id": "1",
                "what": "g/clth/shoe/man::2 pcs",
                "start": "2015.10.16 08:00",
                "end": "",
                "where": "loc1",
                "reason": "",
                "state": "",
                "parentid": ""
              }
            },
            {
              "cmd": "s",
              "content": {
                "id": "1",
                "what": "g/clth/shoe/woman:37:3 pcs",
                "start": "2015.10.16 09:00",
                "end": "",
                "where": "loc2",
                "reason": "",
                "state": "",
                "parentid": ""
              }
            },
            {
              "cmd": "d",
              "content": {
                "id": "2",
                "what": "g/food/veget/turnip::5 kg",
                "start": "2015.10.16 09:00",
                "end": "",
                "where": "loc3",
                "reason": "",
                "state": "",
                "parentid": ""
              }
            }
          ]

}

What main taxonomy:

g - Goods
s - Services
m - money
