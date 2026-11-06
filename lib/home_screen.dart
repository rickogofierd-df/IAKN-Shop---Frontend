import 'dart:async';
import 'package:flutter/material.dart';
import 'produk_screen.dart';
import 'notifikasi_screen.dart';
import 'akun_screen.dart';
import 'keranjang_screen.dart';
import 'detail_produk_screen.dart';

class ProductItem {
  final String id;
  final String tag;
  final Color tagColor;
  final String title;
  final String author;
  final String category;
  final String price;
  final int priceInt;
  final double rating;
  final int reviews;
  final IconData icon;
  final Color iconColor;
  final bool isFlashSale;
  final String? oldPrice;
  final String? discount;
  final String? description;

  const ProductItem({
    required this.id,
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.author,
    required this.category,
    required this.price,
    required this.priceInt,
    required this.rating,
    required this.reviews,
    required this.icon,
    required this.iconColor,
    this.isFlashSale = false,
    this.oldPrice,
    this.discount,
    this.description,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryBlue = const Color(0xFF0000FF);
  final Color darkBlue = const Color(0xFF00008B);

  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;
  String _searchQuery = "";
  String _selectedCategory = "Semua";

  final List<String> _categories = [
    "Semua",
    "Buku/Ilmiah",
    "Alat Musik",
    "Jasa/Layanan",
    "Desain Grafis",
    "Tek. Edukasi",
    "Merchandise",
  ];

  // Complete catalog of IAKN Commerce products
  final List<ProductItem> _allProducts = const [
    ProductItem(
      id: "prod_1",
      tag: "Buku Ilmiah",
      tagColor: Colors.blue,
      title: "Antropologi Musik Maluku & Nusantara",
      author: "Oleh: Prodi Musik Gereja",
      category: "Buku/Ilmiah",
      price: "Rp 85.000",
      priceInt: 85000,
      rating: 4.9,
      reviews: 120,
      icon: Icons.menu_book,
      iconColor: Colors.blue,
    ),
    ProductItem(
      id: "prod_2",
      tag: "Jasa Grafis",
      tagColor: Colors.purple,
      title: "Desain Banner & Publikasi Acara Kampus",
      author: "Kreatif Lab Mahasiswa",
      category: "Desain Grafis",
      price: "Rp 50.000",
      priceInt: 50000,
      rating: 4.8,
      reviews: 85,
      icon: Icons.design_services,
      iconColor: Colors.purple,
    ),
    ProductItem(
      id: "prod_3",
      tag: "Alat Musik",
      tagColor: Colors.deepOrange,
      title: "Tifa Maluku Kayu Ukir Asli",
      author: "Bengkel Seni Kampus",
      category: "Alat Musik",
      price: "Rp 350.000",
      priceInt: 350000,
      rating: 5.0,
      reviews: 25,
      icon: Icons.music_note,
      iconColor: Colors.deepOrange,
    ),
    ProductItem(
      id: "prod_4",
      tag: "Tek. Edukasi",
      tagColor: Colors.teal,
      title: "Media Belajar Interaktif PAUD Kristen",
      author: "Laboratorium FKIP IAKN",
      category: "Tek. Edukasi",
      price: "Rp 125.000",
      priceInt: 125000,
      rating: 4.9,
      reviews: 42,
      icon: Icons.computer,
      iconColor: Colors.teal,
    ),
    ProductItem(
      id: "prod_5",
      tag: "Karya Dosen",
      tagColor: Colors.blue,
      title: "Buku Teologi Kontekstual & Budaya Maluku",
      author: "Penulis: Dosen IAKN",
      category: "Buku/Ilmiah",
      price: "Rp 95.000",
      priceInt: 95000,
      rating: 5.0,
      reviews: 82,
      icon: Icons.menu_book,
      iconColor: Colors.blue,
    ),
    ProductItem(
      id: "prod_6",
      tag: "Flash Sale",
      tagColor: Colors.red,
      title: "Hoodie Dies Natalis IAKN Ke-25",
      author: "Koperasi Mahasiswa IAKN",
      category: "Merchandise",
      price: "Rp 99.000",
      priceInt: 99000,
      rating: 4.9,
      reviews: 165,
      icon: Icons.checkroom,
      iconColor: Colors.indigo,
      isFlashSale: true,
      oldPrice: "165rb",
      discount: "-40%",
    ),
    ProductItem(
      id: "prod_7",
      tag: "Flash Sale",
      tagColor: Colors.red,
      title: "Tumbler Grafir Logo Edisi Ambon",
      author: "Koperasi Mahasiswa",
      category: "Merchandise",
      price: "Rp 45.000",
      priceInt: 45000,
      rating: 4.8,
      reviews: 90,
      icon: Icons.local_drink,
      iconColor: Colors.cyan,
      isFlashSale: true,
      oldPrice: "90rb",
      discount: "-50%",
    ),
    ProductItem(
      id: "prod_8",
      tag: "Kriya Seni",
      tagColor: Colors.deepOrange,
      title: "Miniatur Tifa Khas Maluku Orisinal",
      author: "Sanggar Seni & Kriya Kampus",
      category: "Alat Musik",
      price: "Rp 50.000",
      priceInt: 50000,
      rating: 4.9,
      reviews: 50,
      icon: Icons.music_note,
      iconColor: Colors.deepOrange,
      isFlashSale: true,
      oldPrice: "100rb",
      discount: "-50%",
    ),
    ProductItem(
      id: "prod_9",
      tag: "Layanan Kilat",
      tagColor: Colors.purple,
      title: "Jasa Translate Naskah Ilmiah & Abstrak",
      author: "Unit Bahasa Kampus",
      category: "Jasa/Layanan",
      price: "Rp 35.000",
      priceInt: 35000,
      rating: 4.9,
      reviews: 64,
      icon: Icons.translate,
      iconColor: Colors.purple,
    ),
    ProductItem(
      id: "prod_10",
      tag: "Merchandise BEM",
      tagColor: Colors.pink,
      title: "Totebag Kanvas Motif Tenun Maluku",
      author: "BEM IAKN Ambon",
      category: "Merchandise",
      price: "Rp 45.000",
      priceInt: 45000,
      rating: 4.7,
      reviews: 53,
      icon: Icons.shopping_bag,
      iconColor: Colors.pink,
    ),
    ProductItem(
      id: "prod_11",
      tag: "Karya Mahasiswa",
      tagColor: Colors.green,
      title: "Gitar Akustik Custom Mahasiswa",
      author: "Prodi Pendidikan Seni",
      category: "Alat Musik",
      price: "Rp 750.000",
      priceInt: 750000,
      rating: 4.8,
      reviews: 19,
      icon: Icons.music_note,
      iconColor: Colors.green,
    ),
    ProductItem(
      id: "prod_12",
      tag: "Lisensi Edu",
      tagColor: Colors.teal,
      title: "Software Pembelajaran Liturgi Digital",
      author: "Lab Komputer IAKN",
      category: "Tek. Edukasi",
      price: "Rp 150.000",
      priceInt: 150000,
      rating: 4.9,
      reviews: 31,
      icon: Icons.computer,
      iconColor: Colors.teal,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final nextIndex = (_currentBannerIndex + 1) % 3;
        _bannerController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearching => _searchQuery.isNotEmpty || _selectedCategory != "Semua";

  List<ProductItem> get _filteredProducts {
    return _allProducts.where((product) {
      final query = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.author.toLowerCase().contains(query) ||
          product.tag.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == "Semua" ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();

      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = "";
      _selectedCategory = "Semua";
    });
  }

  void _onCategoryTapped(String category) {
    setState(() {
      _selectedCategory = category;
      // Scroll or clear custom text if desired
    });
  }

  void _addToCart(ProductItem product) {
    setState(() {
      CartManager.addItem(
        title: product.title,
        seller: product.author,
        category: product.category,
        price: product.priceInt,
        icon: product.icon,
        iconColor: product.iconColor,
      );
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "'${product.title}' ditambahkan ke keranjang!",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: "Lihat",
          textColor: Colors.yellowAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KeranjangScreen()),
            ).then((_) {
              if (mounted) setState(() {});
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          color: darkBlue,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            bottom: 12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(Icons.person, color: darkBlue),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "IAKN COMMERCE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Username",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KeranjangScreen()),
                      ).then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(
                        children: [
                          const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                "${CartManager.itemCount}",
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search Bar Active & Functional
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Cari produk di IAKN Ambon...",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: primaryBlue),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = "";
                              });
                            },
                          )
                        : Icon(Icons.tune, color: Colors.grey.shade600),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: _isSearching ? _buildSearchResultsSlivers() : _buildDefaultHomeSlivers(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProdukScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AkunScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Produk"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifikasi"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Akun"),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 1: SEARCH RESULTS VIEW
  // ==========================================
  List<Widget> _buildSearchResultsSlivers() {
    final results = _filteredProducts;

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result Status Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _searchQuery.isNotEmpty
                              ? "Hasil pencarian: '$_searchQuery'"
                              : "Kategori: $_selectedCategory",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${results.length} produk ditemukan",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text("Reset", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Filter Chips in Search View
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _categories.map((cat) {
                    final isSel = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          color: isSel ? Colors.white : Colors.black87,
                        ),
                        selectedColor: primaryBlue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSel ? primaryBlue : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      if (results.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Produk Tidak Ditemukan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tidak ada produk yang cocok dengan pencarian Anda.\nCoba cari kata kunci seperti: Buku, Tifa, Desain, Hoodie, atau Edukasi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _clearSearch,
                  child: const Text("Tampilkan Semua Produk", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = results[index];
                return _buildProductCard(product);
              },
              childCount: results.length,
            ),
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ];
  }

  // ==========================================
  // VIEW 2: DEFAULT HOME DASHBOARD SLIVERS
  // ==========================================
  List<Widget> _buildDefaultHomeSlivers() {
    return [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.campaign, color: primaryBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "INFO KAMPUS TERKINI",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          "Bazar Dies Natalis dibuka di Gedung Auditorium IAKN...",
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Cek",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Categories Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Kategori Pilihan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ProdukScreen()),
                      );
                    },
                    child: Text(
                      "Lihat Semua >",
                      style: TextStyle(color: primaryBlue, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Categories Horizontal List with search filter interaction
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              primary: false,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryItem(Icons.handshake, "Jasa/Layanan"),
                  _buildCategoryItem(Icons.design_services, "Desain Grafis"),
                  _buildCategoryItem(Icons.music_note, "Alat Musik"),
                  _buildCategoryItem(Icons.menu_book, "Buku/Ilmiah"),
                  _buildCategoryItem(Icons.computer, "Tek. Edukasi"),
                  _buildCategoryItem(Icons.checkroom, "Merchandise"),
                ],
              ),
            ),

            // Promo Banner Slider (Swiper dengan 3 Banner)
            _buildPromoBannerSlider(),
            const SizedBox(height: 14),

            // Flash Sale Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.red, size: 20),
                  const SizedBox(width: 4),
                  const Text(
                    "Flash Sale Dies Natalis",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const Spacer(),
                  _buildTimerBox("04"),
                  const Text(" : ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  _buildTimerBox("15"),
                  const Text(" : ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  _buildTimerBox("29"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Flash Sale Horizontal List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              primary: false,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFlashSaleCard("Hoodie Dies Natalis", "Rp 99rb", "165rb", "-40%", "prod_6"),
                  _buildFlashSaleCard("Tumbler Edisi Ambon", "Rp 45rb", "90rb", "-50%", "prod_7"),
                  _buildFlashSaleCard("Miniature Ambon", "Rp 50rb", "100rb", "-50%", "prod_8"),
                ],
              ),
            ),

            // Popular Products Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Produk Terpopuler Kampus",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Karya unggulan mahasiswa dan dosen",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ProdukScreen()),
                      );
                    },
                    child: Text(
                      "Lihat\nSemua >",
                      style: TextStyle(color: primaryBlue, fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Popular Products Grid
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          delegate: SliverChildListDelegate([
            _buildProductCard(_allProducts[0]),
            _buildProductCard(_allProducts[1]),
            _buildProductCard(_allProducts[2]),
            _buildProductCard(_allProducts[3]),
          ]),
        ),
      ),

      // Guarantee Banner
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user, color: primaryBlue, size: 36),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jaminan Kualitas Akademik",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      "Setiap transaksi mendukung langsung dana beasiswa dan riset kreatif mahasiswa IAKN Ambon.",
                      style: TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
    ];
  }

  // ==========================================
  // WIDGET HELPERS
  // ==========================================
  Widget _buildPromoBannerSlider() {
    final banners = [
      // Banner 1: Dies Natalis Expo
      {
        "tag": "DIES NATALIS EXPO",
        "tagBg": Colors.greenAccent,
        "tagColor": const Color(0xFF064E3B),
        "discount": "Diskon 35%",
        "title": "Pekan Inovasi & Kewirausahaan\nMahasiswa",
        "desc": "Karya orisinal sivitas akademika IAKN Ambon: literatur teologi, media ajar, suvenir kriya...",
        "btnText": "Klaim Voucher di Keranjang",
        "btnIcon": Icons.local_offer,
        "btnTextColor": darkBlue,
        "gradient": const [Color(0xFF0000FF), Color(0xFF00008B)],
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KeranjangScreen()),
          ).then((_) {
            if (mounted) setState(() {});
          });
        },
      },
      // Banner 2: Literasi & Buku Ilmiah
      {
        "tag": "LITERASI KAMPUS",
        "tagBg": const Color(0xFFFEF08A),
        "tagColor": const Color(0xFF854D0E),
        "discount": "Hemat 25%",
        "title": "Bazar Buku Ilmiah &\nTeologi Kontekstual",
        "desc": "Koleksi buku referensi & teologi terbitan dosen IAKN. Potongan harga khusus bagi mahasiswa.",
        "btnText": "Jelajahi Buku Ilmiah",
        "btnIcon": Icons.menu_book,
        "btnTextColor": const Color(0xFF115E59),
        "gradient": const [Color(0xFF0D9488), Color(0xFF115E59)],
        "onTap": () => _onCategoryTapped("Buku/Ilmiah"),
      },
      // Banner 3: Seni & Suvenir Budaya Maluku
      {
        "tag": "KARYA KRIYA MALUKU",
        "tagBg": const Color(0xFFFFEDD5),
        "tagColor": const Color(0xFF9A3412),
        "discount": "Edisi Budaya",
        "title": "Pameran Suvenir &\nAlat Musik Tradisional",
        "desc": "Dukung karya Sanggar Seni IAKN: Tifa kayu ukir khas Maluku, kain tenun, dan miniatur orisinal.",
        "btnText": "Lihat Koleksi Seni",
        "btnIcon": Icons.palette,
        "btnTextColor": const Color(0xFF4C1D95),
        "gradient": const [Color(0xFF7C3AED), Color(0xFF4C1D95)],
        "onTap": () => _onCategoryTapped("Alat Musik"),
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner["gradient"] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (banner["gradient"] as List<Color>).first.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: banner["tagBg"] as Color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                banner["tag"] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: banner["tagColor"] as Color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              banner["discount"] as String,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner["title"] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner["desc"] as String,
                          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.25),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: banner["onTap"] as VoidCallback,
                      icon: Icon(banner["btnIcon"] as IconData, size: 16, color: banner["btnTextColor"] as Color),
                      label: Text(
                        banner["btnText"] as String,
                        style: TextStyle(
                          color: banner["btnTextColor"] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (i) {
            final isActive = _currentBannerIndex == i;
            return GestureDetector(
              onTap: () {
                _bannerController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? primaryBlue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

    Widget _buildCategoryItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () => _onCategoryTapped(label),
        borderRadius: BorderRadius.circular(25),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryBlue),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFlashSaleCard(String title, String price, String oldPrice, String discount, String prodId) {
    final prod = _allProducts.firstWhere((p) => p.id == prodId, orElse: () => _allProducts.first);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProdukScreen(product: prod),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: prod.iconColor.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Center(child: Icon(prod.icon, color: prod.iconColor, size: 36)),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    oldPrice,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductItem product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProdukScreen(product: product),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 105,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: product.iconColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Center(child: Icon(product.icon, color: product.iconColor, size: 40)),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    product.tag,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: product.tagColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            "${product.rating}",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " (${product.reviews})",
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.author,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      InkWell(
                        onTap: () => _addToCart(product),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.shopping_cart, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}
