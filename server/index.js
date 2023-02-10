//IMPORTS FROM PACKAGES
const express = require('express');
const bodyParser = require('body-parser')
const cors = require('cors')

//IMPORT FROM OTHER FILES
 const chatgptRouter = require("./routes/chatgpt");



//INIT
const PORT = process.env.PORT || 3000;
const app = express();



//Middleware
app.use(bodyParser.json());
app.use(cors());
app.use(chatgptRouter);




app.listen(PORT, "0.0.0.0", ()=>{
  console.log(`Example app listening at http://localhost:${PORT}`)
})

