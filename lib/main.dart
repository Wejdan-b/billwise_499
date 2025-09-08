import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthSmokeTest(),
    );
  }
}

class AuthSmokeTest extends StatefulWidget {
  const AuthSmokeTest({super.key});
  @override
  State<AuthSmokeTest> createState() => _AuthSmokeTestState();
}

class _AuthSmokeTestState extends State<AuthSmokeTest> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  Future<void> _signup() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text,
      );
      _snack('تم إنشاء الحساب والدخول ✅');
    } on FirebaseAuthException catch (e) {
      _snack(_map(e.code));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text,
      );
      _snack('تم تسجيل الدخول ✅');
    } on FirebaseAuthException catch (e) {
      _snack(_map(e.code));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    _snack('تم تسجيل الخروج');
  }

  String _map(String c) {
    switch (c) {
      case 'invalid-email':
        return 'صيغة الإيميل غير صحيحة';
      case 'email-already-in-use':
        return 'الإيميل مستخدم مسبقًا';
      case 'weak-password':
        return 'كلمة المرور ضعيفة (٦ أحرف فأكثر)';
      case 'user-not-found':
        return 'الحساب غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'operation-not-allowed':
        return 'طريقة الدخول غير مفعّلة في Firebase';
      default:
        return 'خطأ: $c';
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Auth Test'),
        actions: [
          if (user != null)
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text('الحالة: ${user?.email ?? "غير مسجّل"}'),
          const SizedBox(height: 16),
          TextField(
            controller: email,
            decoration: const InputDecoration(labelText: 'الإيميل'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: pass,
            decoration: const InputDecoration(labelText: 'كلمة المرور'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: loading ? null : _login,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('دخول'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: loading ? null : _signup,
                child: const Text('إنشاء حساب'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
