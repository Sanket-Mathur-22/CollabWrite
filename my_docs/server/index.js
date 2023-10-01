const express = require("express");
const mongoose = require('mongoose');
const authRouter = require("./routers/auth");
const cors = require("cors");
const http = require("http");
const documentRouter = require("./routers/document");
const Document = require("./models/document");

const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
var io = require("socket.io")(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

const DB = 'mongodb+srv://Sanket:cg073643@cluster0.fcelzua.mongodb.net/?retryWrites=true&w=majority';

mongoose.connect(DB).then(()=>{
    console.log("Connection Succesfull")
}).catch((err)=>{
    console.log(err);
})

io.on("connection", (socket) => {
    socket.on("join", (documentId) => {
      socket.join(documentId);
    });
  
    socket.on("typing", (data) => {
      socket.broadcast.to(data.room).emit("changes", data);
    });
  
    socket.on("save", (data) => {
      saveData(data);
    });
  });
  const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
  };
  

server.listen(PORT,"0.0.0.0",()=>{
    console.log(`connected to port ${PORT}`);
});