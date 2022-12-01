const express = require('express');
const app = express();
const router = express.Router();
const path = require('path');
const methodOverride = require('method-override');
const cookieParser = require("cookie-parser");
const MongoStore = require('connect-mongo');
const bodyParser = require('body-parser');
const cors = require('cors');

//Especificaciones
app.use(express.static("public"));
app.set('view engine','ejs');
app.set('views',path.join(__dirname,'/views'))
app.use(methodOverride('_method'));
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser());
app.use(cors())

// Paths
//app.get('/',(req,res)=>{var vsession = req.session;res.render('index', { vsession })})
app.get('/',(req,res)=>{res.render('index')})
//add the router
app.use('/', router);
require("./routes.js")(app);

app.listen(process.env.port || 3000);
console.log('Running at Port 3000');