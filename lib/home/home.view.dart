import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _buttonSlideAnimation1;
  late Animation<Offset> _buttonSlideAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _buttonSlideAnimation1 = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _buttonSlideAnimation2 = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToCadastrarDoacoes() {
    Navigator.pushNamed(context, '/cadastrar-doacoes');
  }

  void _navigateToRank() {
    Navigator.pushNamed(context, '/ranking');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006400), // Fundo verde escuro
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF006400), // Verde escuro
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF006400),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Cadastrar Doações'),
              onTap: _navigateToCadastrarDoacoes,
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Rank/Dashboard'),
              onTap: _navigateToRank,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_picture.png'),
              ),
              const SizedBox(height: 20),
              Text(
                'Bem vindo ao seu perfil!',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: const Color(0xFF00FF7F), // Verde claro
                      fontSize: 24,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AnimatedSlide(
                offset: _buttonSlideAnimation1.value,
                duration: const Duration(seconds: 1),
                child: ElevatedButton(
                  onPressed: _navigateToCadastrarDoacoes,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, 
                    backgroundColor: const Color(0xFF00FF7F), // Verde claro
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cadastrar Doações', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSlide(
                offset: _buttonSlideAnimation2.value,
                duration: const Duration(seconds: 1),
                child: ElevatedButton(
                  onPressed: _navigateToRank,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, 
                    backgroundColor: const Color(0xFF00FF7F), // Verde claro
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Rank/Dashboard', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
