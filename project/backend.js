const express = require('express')
const app = express()
const port = 3000

app.get('/tickets', (req, res) => {
  res.send('Hello World!')
})

app.post('/tickets/', (req, res) => {
    
});


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})