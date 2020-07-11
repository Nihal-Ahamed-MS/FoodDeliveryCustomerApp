import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'package:customerapp/Screen/MyBottomNavigationBar.dart';


class SignUp extends StatefulWidget {
  @override
   _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _pass;

  checkingAuth() async {
    firebaseAuth.onAuthStateChanged.listen(
      (user){
        if(user != null){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyBottomNavigationBar()));
      }
      }
    );
  }

  navigateToSignin(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignIn()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkingAuth();
    
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

  signup()async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      try{
        FirebaseUser user = (await firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _pass)).user;
        if(user!=null){
          UserUpdateInfo userUpdateInfo = UserUpdateInfo();
          userUpdateInfo.displayName = _name;
          user.updateProfile(userUpdateInfo);
        }
      }catch(e){
        showError(e.message);
      }
    }
  }


   @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                     key: _formKey,
                     child: Column(
                       children: <Widget>[
                         Container(
                           padding: EdgeInsets.only(top:20.0),
                           child: TextFormField(
                             validator: (input){
                               if(input.isEmpty)
                               {
                                 return "Provide an NAME";
                               }
                             },
                             decoration: InputDecoration(
                               labelText: 'Name',
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                
                               )
                             ),
                             onSaved: (input) => _name = input,
                           ),
                         ),
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
                                 borderRadius: BorderRadius.circular(5.0),
                                
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
                              onPressed: signup,
                               child: Text(
                                  'SIGN UP',
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
                             Text('Already an UI Mart Customer?',
                                style: TextStyle(
                                  fontFamily: 'Montserrat'
                                ),
                             ),
                             SizedBox(width: 5.0,),
                             GestureDetector(
                                onTap: navigateToSignin,
                                child: Text("Login In",
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
