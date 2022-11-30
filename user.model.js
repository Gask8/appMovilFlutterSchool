const mongoose = require('mongoose');
const conection = require("./db.config.js");

const userSchema = new mongoose.Schema({
	nombre: {
		type: [String]
	},
	apellido: {
		type: [String]
	},
	edad: {
		type: [Number]
	},
	sexo: {
		type: [Boolean]
	},
	url_foto: {
		type: [String]
	},
	correo: {
		type: [String]
	},
	password: {
		type: [String]
	},
	esInvitado: {
		type: [Boolean]
	}
});

const User = mongoose.model('User', userSchema);
module.exports = User;