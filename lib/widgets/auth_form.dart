import 'dart:io';

import 'package:chat_app/widgets/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function({
    required BuildContext context,
    required String email,
    required bool isLogin,
    required String password,
    required String username,
    required File? profileImage,
  }) submitToFirebase;
  const AuthForm(this.submitToFirebase, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  final _savedValues = {
    'username': '',
    'email': '',
    'password': '',
  };
  File? _profileImage;

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isloading = false;

  void _setImage(File? image) {
    _profileImage = image;
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _sizeAnimation = Tween<double>(begin: 0, end: 90).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    super.initState();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_profileImage == null&&!_isLogin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('using default image')),
        );
      }
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      setState(() {
        _isloading = true;
      });
      await widget.submitToFirebase(
        context: context,
        email: _savedValues['email']!.trim(),
        isLogin: _isLogin,
        password: _savedValues['password']!.trim(),
        username: _savedValues['username']!.trim(),
        profileImage: _profileImage,
      );
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Card(
        elevation: 10,
        color: theme.colorScheme.secondary,
        margin: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.5 * 0.25),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, ch) {
                        return _sizeAnimation.value <= 0
                            ? const SizedBox()
                            : Row(
                                children: [
                                  FadeTransition(
                                    opacity: _sizeAnimation,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        hintText: 'user name',
                                        label: const Text('user name'),
                                        constraints: BoxConstraints(
                                            maxWidth: mediaQuery.size.width *
                                                0.75 *
                                                0.5,
                                            maxHeight:
                                                _sizeAnimation.value + 30),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value!.length < 4) {
                                          return 'username is short';
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) =>
                                          _savedValues['username'] = newValue!,
                                    ),
                                  ),
                                  Expanded(
                                      child: ProfilePicker(
                                          _sizeAnimation.value, _setImage))
                                ],
                              );
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: 'email address',
                      label: Text('email address'),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _savedValues['email'] = newValue!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: 'password',
                      label: Text('password'),
                    ),
                    onEditingComplete: _submit,
                    obscureText: true,
                    validator: (value) {
                      if (value!.length < 7) {
                        return 'please enter longer password';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _savedValues['password'] = newValue!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) => _sizeAnimation.value <= 0
                        ? const SizedBox()
                        : FadeTransition(
                            opacity: _sizeAnimation,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  hintText: 'confirm password',
                                  label: const Text('confirm password'),
                                  constraints: BoxConstraints(
                                    maxHeight: _sizeAnimation.value + 30,
                                  )),
                              onEditingComplete: _submit,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value != _passwordController.text) {
                                  return 'password doesn\'t match';
                                }
                                return null;
                              },
                            ),
                          ),
                  ),
                  if (_isloading) const CircularProgressIndicator(),
                  if (!_isloading)
                    FilledButton(
                      style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(5)),
                      onPressed: _submit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!_isloading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_isLogin) {
                            _animationController.forward();
                          } else {
                            _animationController.reverse();
                          }
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'create an account?'
                          : 'already have an acconut?'),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
