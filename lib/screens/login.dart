import 'package:flutter/material.dart';
import '../core/database/pos_database.dart';
import 'casherpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1326), 
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Image.asset('assets/images/logo.png',
              width: 200,
              height: 200,
              ),
              
              ),
              SizedBox(height: 20,),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                    Text("POS Authentication", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text("Enter your Username and Password", style: TextStyle(color: Colors.white, fontSize: 16),)
                
                ]
              ),
              SizedBox(height: 20,),
            
           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.badge, color: Colors.grey, size: 20),
                      hintText: ' Username',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.cancel_rounded, color: Colors.grey, size: 20),
                      filled: true,
                      fillColor: Color(0xFF222A3D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey, size: 20),
                      hintText: ' Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.visibility, color: Colors.grey, size: 20),
                      filled: true,
                      fillColor: Color(0xFF222A3D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CD7F6), 
                    foregroundColor: const Color(0xFF121617), 
                    minimumSize: const Size(double.infinity, 55), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    final username = _usernameController.text.trim();
                    final password = _passwordController.text.trim();

                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter username and password"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                  final user = await PosDatabase.instance.login(username, password);

                  if (user != null) {
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const CasherPage()),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid username or password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }

                    
                  },
                  child: const Text(
                    "SIGN IN ➔",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            
            SizedBox(height: 20,), 
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF222A3D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(70),
                              ),
                            ),
                            onPressed: () {
                               
                            },
                            child: const Icon(Icons.fingerprint, size: 30, color: Colors.white),
                        ),
                    ]
            ),),
          ],
        ),),
      ),
    );
  }
}