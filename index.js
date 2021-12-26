const express = require('express')
const ip = require('ip');

const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.status(200).json({
      status: "success ✅",
      ip: ip.address()
  })
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})