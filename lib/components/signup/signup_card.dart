import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reflect/components/signup/signup_icon_btn.dart';
import 'package:reflect/components/signup/signup_passfield.dart';
import 'package:reflect/components/signup/signup_textfield.dart';
import 'package:reflect/constants/colors.dart';
import 'package:reflect/main.dart';
import 'package:reflect/services/auth_service.dart';

class SignUpCard extends ConsumerStatefulWidget {
  final void Function() togglePage;
  const SignUpCard({
    super.key, required this.togglePage
  });

  @override
  ConsumerState<SignUpCard> createState() => _SignUpCardState();
}

class _SignUpCardState extends ConsumerState<SignUpCard> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  String errorMsg = '';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUpWithEmailAndPass() async {
    if(passwordController.text != confirmPasswordController.text){
      setState(() => errorMsg = "Passwords do not match!");
      return;
    }
    String msg = await AuthService.createUserWithEmailAndPassword(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());
    if(msg != '') setState(() => errorMsg = msg);
  }

  void signInWithApple() async {
    String msg = "Apple Sign In is not available yet!";
    if(msg != '') setState(() => errorMsg = msg);
  }

  void signInWithGoogle() async {
    String msg = await AuthService.signInWithGoogle();
    if(msg != '') setState(() => errorMsg = msg);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeManagerProvider); 
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: themeData.brightness == Brightness.dark ? themeData.colorScheme.surface.withOpacity(0.8) : themeData.colorScheme.surface.withOpacity(0.6),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      child: SingleChildScrollView(
        child: Stack( //wrap with scrollable
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Let's get to know you!", style: themeData.textTheme.titleMedium),
                Text("Fill up the registration form to get started.", style:themeData.textTheme.bodyMedium?.copyWith(fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w400)),
            
                const SizedBox(height: 20,),
                SignUpTextField(text: "Name", controller: nameController, themeData: themeData,),
                SignUpTextField(text: "Email", controller: emailController, themeData: themeData),
                SignUpPassField(text: "Password", controller: passwordController, themeData: themeData),
                SignUpPassField(text: "Confirm Password", controller: confirmPasswordController, themeData: themeData),
                
                if(errorMsg != '') Row(
                  children: [
                    Icon(Icons.error, color: Colors.redAccent, size: 16,),
                    SizedBox(width: 5,),
                    Text(errorMsg, style: TextStyle(color: Colors.redAccent, fontSize: 14, fontFamily: "Poppins", fontWeight: FontWeight.w400),)
                  ],
                ),
                SizedBox(height: errorMsg != '' ? 5 : 20,),
            
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: signUpWithEmailAndPass, 
                    style: themeData.elevatedButtonTheme.style,
                    child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w600),),
                  ),
                ),
        
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){},
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(vertical: 0)
                    ),
                    child: Text("Forgot Password?", style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: "Poppins"),)
                  ),
                ),
            
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider(color: Colors.grey, thickness: 2, endIndent: 10,)),
                    Text("Or", style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w400),),
                    Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 10,)),
                  ],
                ),
                SizedBox(height: 5,),
        
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: signInWithGoogle,
                        child: SignUpIconButton(imgSrc: 'google'),
                      ),
                      GestureDetector(
                        onTap: signInWithApple,
                        child: SignUpIconButton(imgSrc: 'apple'),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, fontFamily: "Poppins"),),
                    const SizedBox(width: 5,),
                    TextButton(
                      onPressed: widget.togglePage,
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(vertical: 0)
                      ),
                      child: Text("Log In", style: TextStyle(color: Colors.orangeAccent, fontSize: 14, fontFamily: "Poppins", fontWeight: FontWeight.w600),)
                    )
                  ],
                )
            
            
            
              ],
            ),
          ],
        ),
      ),
    
    );
  }
}