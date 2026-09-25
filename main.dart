import 'package:flutter/material.dart';

void main() => runApp(const TerebarApp());

class Product {
  final String name, unit, emoji, category;
  final int price;
  final bool fresh;
  const Product(this.name, this.unit, this.emoji, this.price, this.category, {this.fresh = true});
}

const products = <Product>[
  Product('گوجه فرنگی', '۱ کیلو', '🍅', 68000, 'سبزیجات'),
  Product('خیار', '۱ کیلو', '🥒', 72000, 'سبزیجات'),
  Product('موز', '۱ کیلو', '🍌', 119000, 'میوه‌ها'),
  Product('سیب قرمز', '۱ کیلو', '🍎', 98000, 'میوه‌ها'),
  Product('پرتقال', '۱ کیلو', '🍊', 89000, 'میوه‌ها'),
  Product('سیب‌زمینی', '۱ کیلو', '🥔', 59000, 'صیفی‌جات'),
  Product('هویج', '۱ کیلو', '🥕', 62000, 'سبزیجات'),
  Product('کیوی', '۱ کیلو', '🥝', 135000, 'میوه‌ها'),
];

class TerebarApp extends StatelessWidget {
  const TerebarApp({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF087F5B));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تره‌بار آنلاین',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        fontFamily: 'sans',
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero, color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final cart = <Product, int>{};
  final search = TextEditingController();
  String selectedCategory = 'همه';

  void add(Product p) => setState(() => cart[p] = (cart[p] ?? 0) + 1);
  void change(Product p, int q) => setState(() { if (q <= 0) cart.remove(p); else cart[p] = q; });
  int get count => cart.values.fold(0, (a, b) => a + b);
  int get total => cart.entries.fold(0, (sum, e) => sum + e.key.price * e.value);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onAdd: add, cartCount: count, onCart: () => setState(() => tab = 1), category: selectedCategory, onCategory: (v) => setState(() => selectedCategory = v)),
      CartPage(cart: cart, total: total, onChanged: change, onCheckout: () => showCheckout(context)),
      const OrdersPage(),
      ProfilePage(onSupport: () => showContact(context)),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(child: IndexedStack(index: tab, children: pages)),
        bottomNavigationBar: NavigationBar(
          height: 72,
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'خانه'),
            NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag_rounded), label: 'سبد خرید'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'سفارش‌ها'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'حساب من'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final void Function(Product) onAdd;
  final int cartCount;
  final VoidCallback onCart;
  final String category;
  final ValueChanged<String> onCategory;
  const HomePage({super.key, required this.onAdd, required this.cartCount, required this.onCart, required this.category, required this.onCategory});

  @override
  Widget build(BuildContext context) {
    final cats = ['همه', 'میوه‌ها', 'سبزیجات', 'صیفی‌جات'];
    final visible = category == 'همه' ? products : products.where((p) => p.category == category).toList();
    return CustomScrollView(
      slivers: [
        SliverPadding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 0), sliver: SliverToBoxAdapter(child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('سلام 👋', style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 3),
            Text('تازه‌ها رو بفرستیم؟', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          ])),
          Stack(clipBehavior: Clip.none, children: [
            IconButton.filledTonal(onPressed: onCart, icon: const Icon(Icons.shopping_bag_outlined)),
            if (cartCount > 0) Positioned(left: -2, top: -3, child: Container(width: 20, height: 20, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle), alignment: Alignment.center, child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
          ])
        ]))),
        SliverPadding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 0), sliver: SliverToBoxAdapter(child: TextField(readOnly: true, onTap: () => showSearch(context: context, delegate: ProductSearchDelegate(onAdd)), decoration: const InputDecoration(hintText: 'جستجوی میوه، سبزی و ...', prefixIcon: Icon(Icons.search), suffixIcon: Icon(Icons.tune_rounded))))),
        SliverPadding(padding: const EdgeInsets.fromLTRB(18, 16, 18, 0), sliver: SliverToBoxAdapter(child: Container(
          height: 158,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF075C43), Color(0xFF21A875)])),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: const [
              Text('سبد تازه‌ی امروز', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              SizedBox(height: 7),
              Text('میوه و سبزی تازه،
سریع تا درِ خونه.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
              SizedBox(height: 10),
              Text('تحویل در همان روز', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ])),
            Container(width: 92, height: 92, decoration: BoxDecoration(color: Colors.white.withOpacity(.14), shape: BoxShape.circle), alignment: Alignment.center, child: const Text('🧺', style: TextStyle(fontSize: 52))),
          ]),
        ))),
        SliverToBoxAdapter(child: SectionTitle(title: 'دسته‌بندی‌ها', action: 'محبوب‌ترین‌ها')),
        SliverToBoxAdapter(child: SizedBox(height: 91, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 18), scrollDirection: Axis.horizontal, itemCount: cats.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (_, i) {
          final active = category == cats[i];
          final emoji = {'همه': '✨', 'میوه‌ها': '🍎', 'سبزیجات': '🥬', 'صیفی‌جات': '🥔'}[cats[i]]!;
          return InkWell(onTap: () => onCategory(cats[i]), borderRadius: BorderRadius.circular(20), child: AnimatedContainer(duration: const Duration(milliseconds: 180), width: 82, padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: active ? const Color(0xFFE1F4EC) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? const Color(0xFF21A875) : Colors.transparent)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(emoji, style: const TextStyle(fontSize: 27)), const SizedBox(height: 4), Text(cats[i], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: active ? const Color(0xFF087F5B) : Colors.black87))])));
        })) ),
        SliverToBoxAdapter(child: SectionTitle(title: 'پیشنهاد امروز', action: 'تازه و پرفروش')),
        SliverPadding(padding: const EdgeInsets.fromLTRB(18, 0, 18, 24), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context, i) => ProductCard(product: visible[i], onAdd: () => onAdd(visible[i])), childCount: visible.length), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .67))),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget { final String title, action; const SectionTitle({super.key, required this.title, required this.action}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(18, 22, 18, 12), child: Row(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const Spacer(), Text(action, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700))])); }

class ProductCard extends StatelessWidget {
  final Product product; final VoidCallback onAdd;
  const ProductCard({super.key, required this.product, required this.onAdd});
  @override Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x09000000), blurRadius: 18, offset: Offset(0, 5))]),
    padding: const EdgeInsets.all(12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Stack(children: [Center(child: Container(width: 105, height: 105, decoration: const BoxDecoration(color: Color(0xFFF4F7F5), shape: BoxShape.circle), alignment: Alignment.center, child: Text(product.emoji, style: const TextStyle(fontSize: 65)))), if (product.fresh) Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE5F6EE), borderRadius: BorderRadius.circular(20)), child: const Text('تازه', style: TextStyle(fontSize: 9, color: Color(0xFF087F5B), fontWeight: FontWeight.w800))))])),
      Text(product.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      const SizedBox(height: 3),
      Text(product.unit, style: const TextStyle(color: Colors.black45, fontSize: 10)),
      const SizedBox(height: 7),
      Row(children: [Expanded(child: Text('${money(product.price)} تومان', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12))), IconButton.filled(onPressed: onAdd, icon: const Icon(Icons.add_rounded, size: 19), padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 38, height: 38))]),
    ]),
  );
}

class CartPage extends StatelessWidget {
  final Map<Product, int> cart; final int total; final void Function(Product, int) onChanged; final VoidCallback onCheckout;
  const CartPage({super.key, required this.cart, required this.total, required this.onChanged, required this.onCheckout});
  @override Widget build(BuildContext context) {
    if (cart.isEmpty) return const EmptyState(icon: Icons.shopping_bag_outlined, title: 'سبد خریدت خالیه', subtitle: 'محصولات تازه رو انتخاب کن و سفارشت رو همین امروز ثبت کن.');
    return Column(children: [const Header(title: 'سبد خرید'), Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 18), children: cart.entries.map((e) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(children: [Container(width: 58, height: 58, decoration: const BoxDecoration(color: Color(0xFFF4F7F5), shape: BoxShape.circle), alignment: Alignment.center, child: Text(e.key.emoji, style: const TextStyle(fontSize: 35))), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e.key.name, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text('${money(e.key.price)} تومان', style: const TextStyle(color: Colors.black54, fontSize: 11))])), Row(children: [IconButton(onPressed: () => onChanged(e.key, e.value - 1), icon: const Icon(Icons.remove_circle_outline)), Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.w900)), IconButton(onPressed: () => onChanged(e.key, e.value + 1), icon: const Icon(Icons.add_circle_outline))])]))).toList())), Container(padding: const EdgeInsets.fromLTRB(18, 12, 18, 18), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))), child: Column(children: [Row(children: [const Text('جمع سبد', style: TextStyle(color: Colors.black54)), const Spacer(), Text('${money(total)} تومان', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18))]), const SizedBox(height: 12), FilledButton.icon(onPressed: onCheckout, icon: const Icon(Icons.schedule), label: const Text('انتخاب زمان تحویل'), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)))]))]);
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override Widget build(BuildContext context) => Column(children: [const Header(title: 'سفارش‌های من'), Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 20), children: [
    OrderCard(number: '۱۲۴۸', date: 'امروز • ۱۶ تا ۱۸', status: 'در حال آماده‌سازی', icon: Icons.local_shipping_outlined),
    SizedBox(height: 10),
    OrderCard(number: '۱۲۳۹', date: 'دیروز • ۱۰ تا ۱۲', status: 'تحویل شد', icon: Icons.check_rounded),
    SizedBox(height: 10),
    OrderCard(number: '۱۲۱۶', date: '۲ روز پیش', status: 'تحویل شد', icon: Icons.check_rounded),
  ]))]);
}

class OrderCard extends StatelessWidget { final String number, date, status; final IconData icon; const OrderCard({super.key, required this.number, required this.date, required this.status, required this.icon}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFE8F5F0), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: const Color(0xFF087F5B))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('سفارش #$number', style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(date, style: const TextStyle(color: Colors.black45, fontSize: 11))]), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: status == 'تحویل شد' ? const Color(0xFFE8F5F0) : const Color(0xFFFFF3D9), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: status == 'تحویل شد' ? const Color(0xFF087F5B) : const Color(0xFF9A6A00))))])); }

class ProfilePage extends StatelessWidget {
  final VoidCallback onSupport;
  const ProfilePage({super.key, required this.onSupport});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 28), children: [
    const Text('حساب من', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)), const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)), child: Row(children: [const CircleAvatar(radius: 31, backgroundColor: Color(0xFFE5F4EE), child: Icon(Icons.person_rounded, color: Color(0xFF087F5B), size: 34)), const SizedBox(width: 13), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('کاربر تره‌بار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), SizedBox(height: 5), Text('۰۹۱۲ •••• ۱۲۳۴', style: TextStyle(color: Colors.black45, fontSize: 12))]), const Spacer(), Icon(Icons.edit_outlined, size: 20, color: Colors.black45)])),
    const SizedBox(height: 12), Row(children: [Expanded(child: InfoBox(icon: Icons.shopping_bag_outlined, value: '۷', label: 'تعداد خرید')), const SizedBox(width: 8), Expanded(child: InfoBox(icon: Icons.favorite_border_rounded, value: '۳', label: 'علاقه‌مندی‌ها')), const SizedBox(width: 8), Expanded(child: InfoBox(icon: Icons.location_on_outlined, value: '۲', label: 'آدرس‌ها'))]),
    const SizedBox(height: 14),
    Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)), child: Column(children: [ProfileItem(icon: Icons.location_on_outlined, title: 'آدرس‌های من', subtitle: 'مدیریت آدرس‌های تحویل', onTap: () {}), const Divider(height: 1, indent: 60), ProfileItem(icon: Icons.support_agent_rounded, title: 'ارتباط با مدیریت', subtitle: 'پشتیبانی، پیشنهاد و انتقاد', onTap: onSupport), const Divider(height: 1, indent: 60), ProfileItem(icon: Icons.notifications_none_rounded, title: 'اعلان‌ها', subtitle: 'تخفیف‌ها و تغییر قیمت‌ها', onTap: () {}), const Divider(height: 1, indent: 60), ProfileItem(icon: Icons.info_outline_rounded, title: 'درباره تره‌بار آنلاین', subtitle: 'نسخه ۰.۱', onTap: () {})])),
    const SizedBox(height: 16), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEAF6F1), borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.verified_outlined, color: Color(0xFF087F5B)), SizedBox(width: 10), Expanded(child: Text('خرید راحت، تحویل سر وقت و پشتیبانی مستقیم مدیریت.', style: TextStyle(fontSize: 12, height: 1.5, fontWeight: FontWeight.w700, color: Color(0xFF075C43))))]))
  ]);
}

class ProfileItem extends StatelessWidget { final IconData icon; final String title, subtitle; final VoidCallback onTap; const ProfileItem({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap}); @override Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFF0F5F3), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: const Color(0xFF087F5B))), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black45)), trailing: const Icon(Icons.chevron_left_rounded), onTap: onTap); }
class InfoBox extends StatelessWidget { final IconData icon; final String value, label; const InfoBox({super.key, required this.icon, required this.value, required this.label}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [Icon(icon, color: const Color(0xFF087F5B), size: 20), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(fontSize: 9, color: Colors.black45))])); }

class Header extends StatelessWidget { final String title; const Header({super.key, required this.title}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 8), child: Row(children: [Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)), const Spacer(), IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.more_horiz))])); }

class EmptyState extends StatelessWidget { final IconData icon; final String title, subtitle; const EmptyState({super.key, required this.icon, required this.title, required this.subtitle}); @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(35), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 110, height: 110, decoration: const BoxDecoration(color: Color(0xFFEAF4F0), shape: BoxShape.circle), child: Icon(icon, size: 54, color: const Color(0xFF087F5B))), const SizedBox(height: 18), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 7), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black45, height: 1.5))]))); }

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final void Function(Product) onAdd;
  ProductSearchDelegate(this.onAdd);
  @override List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  @override Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));
  @override Widget buildResults(BuildContext context) => _results();
  @override Widget buildSuggestions(BuildContext context) => _results();
  Widget _results() { final list = products.where((p) => p.name.contains(query) || p.category.contains(query)).toList(); return Directionality(textDirection: TextDirection.rtl, child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: list.length, itemBuilder: (_, i) { final p = list[i]; return ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 5), leading: CircleAvatar(backgroundColor: const Color(0xFFF0F5F3), child: Text(p.emoji)), title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('${money(p.price)} تومان'), trailing: IconButton.filled(onPressed: () { onAdd(p); close(context, p); }, icon: const Icon(Icons.add)); })); }
}

void showCheckout(BuildContext context) {
  showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (c) => Directionality(textDirection: TextDirection.rtl, child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(c).viewInsets.bottom + 24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('زمان تحویل', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('چه زمانی دوست داری سفارشت به دستت برسه؟', style: TextStyle(color: Colors.black54)), const SizedBox(height: 14), ...['امروز، ۱۴ تا ۱۶', 'امروز، ۱۶ تا ۱۸', 'فردا، ۱۰ تا ۱۲'].map((x) => ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), tileColor: const Color(0xFFF6F8F7), title: Text(x, style: const TextStyle(fontWeight: FontWeight.w700)), leading: const Icon(Icons.access_time_rounded), trailing: const Icon(Icons.chevron_left_rounded), onTap: () { Navigator.pop(c); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سفارش با موفقیت ثبت شد و در حال آماده‌سازی است.'))); }))]))));
}

void showContact(BuildContext context) {
  showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (c) => Directionality(textDirection: TextDirection.rtl, child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(c).viewInsets.bottom + 24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(width: 54, height: 54, decoration: const BoxDecoration(color: Color(0xFFE7F5EF), shape: BoxShape.circle), child: const Icon(Icons.support_agent_rounded, color: Color(0xFF087F5B), size: 30)),
    const SizedBox(height: 12), const Text('ارتباط با مدیریت', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('مشکل، پیشنهاد یا انتقادی داری؟ مستقیم بهمون بگو.', style: TextStyle(color: Colors.black54)), const SizedBox(height: 16),
    TextField(maxLines: 4, decoration: const InputDecoration(hintText: 'پیامت رو اینجا بنویس...')),
    const SizedBox(height: 12), Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.phone_outlined), label: const Text('تماس با مدیریت'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)))), const SizedBox(width: 10), Expanded(child: FilledButton.icon(onPressed: () { Navigator.pop(c); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پیامت برای مدیریت ارسال شد.'))); }, icon: const Icon(Icons.send_rounded), label: const Text('ارسال پیام'), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52))))]),
  ])));
}

String money(int n) => n.toString().replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (_) => ',');
