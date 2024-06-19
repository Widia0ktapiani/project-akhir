const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { Users } = require('../models');
const path = require('path');

class UserController {
  static async login(req, res) {
    const { username, password } = req.body;
    try {
      const user = await Users.findOne({ where: { username } });

      if (!user) return res.status(400).json({ error: 'Invalid username or password' });

      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) return res.status(400).json({ error: 'Invalid username or password' });

      const token = jwt.sign({ id: user.id }, 'jwt_secret', { expiresIn: '1h' });
      res.json({ token });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  }

  static async register(req, res) {
    const { username, password } = req.body;
    const image = req.file ? req.file.path : null;

    try {
      // Memeriksa apakah username sudah ada
      const existingUser = await Users.findOne({ where: { username } });
      if (existingUser) {
        return res.status(400).json({ error: 'Username sudah ada' });
      }

      const hashedPassword = await bcrypt.hash(password, 10);
      const user = await Users.create({ username, password: hashedPassword, image });
      res.status(201).json({ message: 'Akun Anda berhasil dibuat.' });
    } catch (error) {
      res.status(500).json({ error: 'Terjadi kesalahan saat membuat akun.' });
    }
  }
}

//   static async register(req, res) {
//     const { username, password } = req.body;
//     const image = req.file ? req.file.path : null;

//     try {
//       const hashedPassword = await bcrypt.hash(password, 10);
//       const user = await Users.create({ username, password: hashedPassword, image });
//       res.status(201).json(user);
//     } catch (error) {
//       res.status(500).json({ error: error.message });
//     }
//   }
// }

  // static async register(req, res) {
  //   const { username, password } = req.body;
  //   const image = req.files && req.files.image ? `http://10.10.11.182:3000/uploads/users/${req.files.image[0].filename}` : null;

  //   try {
  //     const hashedPassword = await bcrypt.hash(password, 10);
  //     const user = await Users.create({ username, password: hashedPassword, image });
  //     res.status(201).json(user);
  //   } catch (error) {
  //     res.status(500).json({ error: error.message });
  //   }
  // }
  //   const { username, password, image } = req.body;
  //   try {
  //     const hashedPassword = await bcrypt.hash(password, 10);
  //     const user = await Users.create({ username, password: hashedPassword, image });
  //     res.json(user);
  //   } catch (error) {
  //     console.error(error);
  //     res.status(500).json({ error: 'Internal Server Error' });
  //   }
  // }

module.exports = UserController;
