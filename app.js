const express = require('express');
const app = express();
const router = express.Router();
const path = require('path');
const methodOverride = require('method-override');
const cookieParser = require("cookie-parser");
const sessions = require('express-session');
const session = require('express-session');
const MongoStore = require('connect-mongo');
const bodyParser = require('body-parser');

// session
const store = MongoStore.create({
	mongoUrl: "mongodb+srv://gadmin:gz695VWqzWeSnSxr@cluster0.d74y6.mongodb.net/tinder?retryWrites=true&w=majority",
	secret: 'secretkey',
	touchAfter: 24*60*60
})
const sessionConfig = {
	store,
	name: "session",
	secret: 'secretkey',
	resave: false,
	saveUninitialized: false,
	cookie: {
		httpOnly: true,
		expires: Date.now() + 1000 * 60 *60 * 24 * 7,
		maxAge: 1000 * 60 *60 * 24 * 7
	}
}
//Especificaciones
app.use(express.static('public'))
app.set('view engine','ejs');
app.set('views',path.join(__dirname,'/views'))
app.use(methodOverride('_method'));
//app.use(express.urlencoded({ extended: true }));
//app.use(express.json());
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser());
app.use(sessions(sessionConfig));

// Paths
//app.get('/',(req,res)=>{var vsession = req.session;res.render('index', { vsession })})
app.get('/',(req,res)=>{res.send("Proyecto Final")})
app.post("/prueba", async(req, res)=>{res.send(req.body);});
app.get("/prueba2", async(req, res)=>{res.send(req.body);});
//add the router
app.use('/', router);
require("./routes.js")(app);

app.listen(process.env.port || 3000);
console.log('Running at Port 3000');