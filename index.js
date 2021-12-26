const express = require('express')
const ip = require('ip');
let cpu = require('cpu-load')
const { sleep } = require('sleep');

const app = express()
const port = 3000

app.get('/', async (req, res) => {
  res.status(200).json({
      status: "success ✅",
      ip: ip.address(),
  })
})

app.get('/load', async (req, res) => {
    let load = await load_cpu();
    res.status(200).json({
        status: "success ✅",
        load
    })
  })

  app.get('/stress10', async (req, res) => {
    
    sleep(10);
    
    res.status(200).json({
        message: "stress successfull for 10 secs",
        status: "success ✅",
        
    })
  })

  app.get('/stress5', async (req, res) => {
    
    sleep(5);
    
    res.status(200).json({
        message: "stress successfull for 10 secs",
        status: "success ✅",
        
    })
  })

function load_cpu(){
    return new Promise ((resolve, reject) => {
        load = cpu(1000, function (load) {
            resolve(load)
          })
    })
}

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})