module.exports = app => {
	const User = require("./user.model.js");
	
	// ALL Get
  app.get("/getAll", async(req, res)=>{
	  const users = await User.find({});
	  //const users = await Evaluado.find({idt:idt});
	  //const vsession = req.session;
	  //res.render('evaluado/all',{ idt, evaluados, vsession })
	  res.send(users);
  });
	
	
	// New Post
  app.post("/addOne", async(req, res)=>{
	  const data = req.body;
	  console.log(data);
	  console.log(req.body.nombre);
	  await User.create(data, function(err, result){
		  if(err){
			  res.send(err);
		  }});
	  res.send(data);
  });
	
};