import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/state/omni_state.dart';
import 'core/theme/omni_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/opportunities_screen.dart';
import 'screens/jobs_screen.dart';
import 'screens/proposals_screen.dart';
import 'screens/service_orders_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/financial_screen.dart';
import 'screens/omni_recovery_screen.dart';
import 'screens/admin_screen.dart';
import 'widgets/coins_wallet_sheet.dart';
import 'widgets/client_request_sheet.dart';
import 'widgets/omni_ui.dart';

class OmniMarketplaceApp extends StatelessWidget {
  const OmniMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OmniAppState(),
      child: MaterialApp(
        title: 'OMNI Marketplace Profissionais',
        debugShowCheckedModeBanner: false,
        theme: OmniTheme.darkTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        home: const OmniHomeScreen(),
      ),
    );
  }
}

class OmniHomeScreen extends StatelessWidget {
  const OmniHomeScreen({super.key});

  static const Map<String, Map<String, String>> _roleMeta = {
    'profissional': {'label': 'Profissional Autônomo', 'short': 'Autônomo', 'icon': '⚖️'},
    'empresa': {'label': 'Empresa Prestadora', 'short': 'Empresa', 'icon': '🏢'},
    'escritorio': {'label': 'Escritório Multidisciplinar', 'short': 'Escritório', 'icon': '🏛️'},
    'instituicao': {'label': 'Instituição / Cartório', 'short': 'Cartório', 'icon': '📜'},
    'cliente': {'label': 'Empresa Demandante', 'short': 'Demandante', 'icon': '💼'},
    'admin': {'label': 'Administrador Master', 'short': 'Admin', 'icon': '🛡️'},
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();

    final List<Map<String, dynamic>> navTabs = [
      {
        'id': 'dashboard',
        'label': 'Painel',
        'icon': Icons.dashboard_outlined,
      },
      {
        'id': 'oportunidades',
        'label': 'Oportunidades',
        'badge': state.opportunities.length,
        'icon': Icons.work_outline,
      },
      {
        'id': 'vagas_empregos',
        'label': 'Vagas & Empregos',
        'icon': Icons.groups_outlined,
      },
      {
        'id': 'propostas',
        'label': 'Propostas',
        'icon': Icons.layers_outlined,
      },
      {
        'id': 'ordens_servico',
        'label': 'Ordens (OS)',
        'badge': state.orders.length,
        'icon': Icons.assignment_turned_in_outlined,
      },
      {
        'id': 'documentos',
        'label': 'Cofre Documental',
        'icon': Icons.verified_user_outlined,
      },
      {
        'id': 'chat',
        'label': 'Chat da OS',
        'icon': Icons.chat_bubble_outline,
      },
      {
        'id': 'financeiro',
        'label': 'Financeiro & Pix',
        'icon': Icons.credit_card_outlined,
      },
      {
        'id': 'omni_recuperacao',
        'label': 'OMNI Recuperação',
        'icon': Icons.apartment,
      },
      {
        'id': 'admin_panel',
        'label': 'Governança Admin',
        'icon': Icons.shield_outlined,
      },
    ];

    final bottomIds = [
      'dashboard',
      'oportunidades',
      'vagas_empregos',
      'ordens_servico',
      'financeiro',
    ];
    final bottomIndex = bottomIds.indexOf(state.currentTab);

    return Scaffold(
      backgroundColor: OmniTheme.backgroundBlack,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Cabeçalho Superior Fixo idêntico ao HeaderNav.tsx
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: OmniTheme.backgroundBlack.withOpacity(0.96),
                border: const Border(
                  bottom: BorderSide(color: OmniTheme.borderSubtle, width: 1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Brand Zone: Logo Ω com Glow Neon
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [OmniTheme.neonGreen, OmniTheme.neonGreenDark],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: OmniTheme.neonGlow(opacity: 0.35, blur: 12),
                        ),
                        child: const Center(
                          child: Text(
                            'Ω',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'OMNI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: OmniTheme.neonGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color:
                                          OmniTheme.neonGreen.withOpacity(0.35)),
                                ),
                                child: Text(
                                  'MARKETPLACE PRO',
                                  style: monoStyle(
                                    color: OmniTheme.neonGreen,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Profissionais & Cartórios',
                            style: TextStyle(
                              color: OmniTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Moedas GetNinjas Pill com glow âmbar
                      GestureDetector(
                        onTap: () => showCoinsWalletSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121C29),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: OmniTheme.alertAmber.withOpacity(0.45)),
                            boxShadow:
                                OmniTheme.amberGlow(opacity: 0.16, blur: 8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🪙 ', style: TextStyle(fontSize: 12)),
                              Text(
                                '${state.saldoMoedas}',
                                style: monoStyle(
                                  color: OmniTheme.alertAmber,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Botão Rápido: Pedir Serviço
                      GestureDetector(
                        onTap: () => showClientRequestSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: OmniTheme.neonGreen,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: OmniTheme.neonGlow(opacity: 0.25, blur: 8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_circle_outline,
                                  size: 13, color: Colors.black),
                              SizedBox(width: 3),
                              Text(
                                'Pedir',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Seletor de Papel (Role Switcher)
                      PopupMenuButton<String>(
                        color: const Color(0xFF0F141F),
                        onSelected: (role) {
                          state.setRole(role);
                          showOmniToast(
                            context,
                            'Visualização alterada para ${_roleMeta[role]?['label'] ?? role}',
                          );
                        },
                        itemBuilder: (_) => _roleMeta.entries
                            .map((e) => PopupMenuItem<String>(
                                  value: e.key,
                                  child: Text(
                                    '${e.value['icon']} ${e.value['label']}',
                                    style: TextStyle(
                                      color: state.currentRole == e.key
                                          ? OmniTheme.neonGreen
                                          : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ))
                            .toList(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10141D),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: OmniTheme.borderSubtle),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_roleMeta[state.currentRole]?['icon'] ?? '⚖️'} ${_roleMeta[state.currentRole]?['short'] ?? 'Perfil'}',
                                style: const TextStyle(
                                  color: OmniTheme.neonGreen,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  size: 14, color: OmniTheme.neonGreen),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),

                      // Sino de Notificações com ponto neon
                      GestureDetector(
                        onTap: () => _showNotificationsSheet(context, state),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10141D),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: OmniTheme.borderSubtle),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.notifications_none,
                                  size: 16, color: Color(0xFFCBD5E1)),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: OmniTheme.neonGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),

                  // Faixa Horizontal Fluida de Subnavegação (Todos os 10 módulos igual ao HeaderNav mobile)
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: OmniTheme.borderFaint, width: 1),
                      ),
                    ),
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: navTabs.length,
                      itemBuilder: (_, idx) {
                        final item = navTabs[idx];
                        final active = state.currentTab == item['id'];
                        final badge = item['badge'] as int?;
                        return GestureDetector(
                          onTap: () => state.setTab(item['id'] as String),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: active
                                  ? OmniTheme.surfaceCardActive
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: active
                                    ? OmniTheme.neonGreen.withOpacity(0.45)
                                    : Colors.transparent,
                              ),
                              boxShadow: active
                                  ? OmniTheme.neonGlow(opacity: 0.14, blur: 8)
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  size: 13,
                                  color: active
                                      ? OmniTheme.neonGreen
                                      : OmniTheme.textSecondary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                    color: active
                                        ? OmniTheme.neonGreen
                                        : OmniTheme.textSecondary,
                                    fontSize: 11.5,
                                    fontWeight: active
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                if (badge != null && badge > 0) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '($badge)',
                                    style: monoStyle(
                                      color: OmniTheme.neonGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Viewport Principal
            Expanded(child: _buildCurrentScreen(state.currentTab)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: OmniTheme.backgroundBlack,
            border: Border(top: BorderSide(color: OmniTheme.borderSubtle)),
          ),
          child: BottomNavigationBar(
            currentIndex: bottomIndex == -1 ? 0 : bottomIndex,
            onTap: (index) => state.setTab(bottomIds[index]),
            backgroundColor: OmniTheme.backgroundBlack,
            elevation: 0,
            selectedItemColor: OmniTheme.neonGreen,
            unselectedItemColor: OmniTheme.textSecondary,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined), label: 'Painel'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.work_outline), label: 'Pedidos'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.groups_outlined), label: 'Vagas'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_turned_in_outlined),
                  label: 'Ordens'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card_outlined), label: 'Pix'),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context, OmniAppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          color: Color(0xFF0E131D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: OmniTheme.neonGreen, width: 1.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NOTIFICAÇÕES EM TEMPO REAL',
                  style: monoStyle(
                    color: OmniTheme.neonGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon:
                      const Icon(Icons.close, color: OmniTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...state.notifications.take(5).map((n) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: OmniTheme.surfaceInner,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: OmniTheme.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.circle,
                          size: 8, color: OmniTheme.neonGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          n,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen(String tab) {
    switch (tab) {
      case 'dashboard':
        return const DashboardScreen();
      case 'oportunidades':
        return const OpportunitiesScreen();
      case 'vagas_empregos':
        return const JobsBoardScreen();
      case 'propostas':
        return const ProposalsScreen();
      case 'ordens_servico':
        return const ServiceOrdersScreen();
      case 'documentos':
        return const DocumentsVaultScreen();
      case 'chat':
        return const ChatScreen();
      case 'financeiro':
        return const FinancialScreen();
      case 'omni_recuperacao':
        return const OmniRecoveryScreen();
      case 'admin_panel':
        return const AdminPanelScreen();
      default:
        return const DashboardScreen();
    }
  }
}
