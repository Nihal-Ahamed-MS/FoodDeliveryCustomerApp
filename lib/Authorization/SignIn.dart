import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:customerapp/Screen/MyBottomNavigationBar.dart';
import 'SignUp.dart';
import 'package:customerapp/Screen/HomePage.dart';
class SignIn extends StatefulWidget {
  @override
   _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String _email, _pass;

  checkAuth(){
    _auth.onAuthStateChanged.listen((user) async {
      if(user != null){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyBottomNavigationBar()));
      }
    });
  }

  navigaToSignup(){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUp()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  void signIn() async {
    if(_form.currentState.validate()){
      _form.currentState.save();
    try{
      FirebaseUser user = ( await _auth.signInWithEmailAndPassword(email: _email, password: _pass)).user;
    }
    catch (e){
      showError(e.message);
    }

    }

   
  }

  showError(String error){
    showDialog(context: context,
      builder: (BuildContext){
        return AlertDialog(
          title: Text("Error"),
          content: Text(error),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("OK"))
          ],
        );
      }
    );
  }

   @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
               child: Stack(
                 children: <Widget>[
                   Container(
                     padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                     child: Text(
                       'Ui',
                       style: TextStyle(
                         fontSize: 80.0,
                         fontWeight: FontWeight.bold
                       ),
                     ),
                   ),
                    Container(
                     padding: EdgeInsets.fromLTRB(15.0, 180.0, 0.0, 0.0),
                     child: Text(
                       'Mart',
                       style: TextStyle(
                         fontSize: 80.0,
                         fontWeight: FontWeight.bold
                       ),
                     ),
                   ),
                    Container(
                     padding: EdgeInsets.fromLTRB(200.0, 180.0, 0.0, 0.0),
                     child: Text(
                       '.',
                       style: TextStyle(
                         fontSize: 80.0,
                         fontWeight: FontWeight.bold,
                         color: Colors.blueAccent
                       ),
                     ),
                   )
                 ],
               ),
             ),
             Container(
               padding: EdgeInsets.all(15.0),
               child: Form(
                 key: _form,
                 child: Column(
                   children: <Widget>[
                      Container(
                           padding: EdgeInsets.only(top:20.0),
                           child: TextFormField(
                             validator: (input){
                               if(input.isEmpty)
                               {
                                 return "Provide an email";
                               }
                             },
                             decoration: InputDecoration(
                               labelText: 'Email',
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                
                               )
                             ),
                             onSaved: (input) => _email = input,
                           ),
                         ),
                          Container(
                           padding: EdgeInsets.only(top:20.0),
                           child: TextFormField(
                             validator: (input){
                               if(input.length < 6)
                               {
                                 return "6 character is must";
                               }
                             },
                             decoration: InputDecoration(
                               labelText: 'Password',
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(10.0),
                                
                               )
                             ),
                             onSaved: (input) => _pass = input,
                             obscureText: true,
                           ),
                         ),
                         SizedBox(height: 20.0,),
                         Container(
                          
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(40.0),
                            shadowColor: Colors.blueAccent,
                            color: Colors.blueAccent,
                            elevation: 7.0,
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: signIn,
                               child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15
                                  )
                                )
                            )
                          ),
                         ),
                         SizedBox(height: 20.0,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text('New to UI Mart?',
                                style: TextStyle(
                                  fontFamily: 'Montserrat'
                                ),
                             ),
                             SizedBox(width: 5.0,),
                             GestureDetector(
                                onTap: navigaToSignup,
                                child: Text("Register",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue
                                ),
                                )
                              )
                           ],
                         ), 
                   ],
                 ),
               )
             )
          ],
        ),
      ),
    );
   }
} 

