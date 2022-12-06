const LINK = "mongodb://localhost:27017/tinder";
const LINKM = "mongodb+srv://user:password@cluster0.d74y6.mongodb.net/tinder?retryWrites=true&w=majority";
const mongoose = require('mongoose');
const connection = mongoose.connect(LINKM)
	.then(()=>{
	console.log("Successfully connected to the database.");
})
	.catch(()=>{
	console.log("ERROR EN DB");
	console.log(err);
});

module.exports = connection;
