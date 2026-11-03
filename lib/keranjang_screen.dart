import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'produk_screen.dart';

class CartItem {
  final String id;
  final String title;
  final String seller;
  final String category;
  final String? variant;
  final int price;
  final IconData icon;
  final Color iconColor;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.title,
    required this.seller,
    required this.category,
    this.variant,
    required this.price,
    required this.icon,
    required this.iconColor,
    this.quantity = 1,
    this.isSelected = true,
  });
}

class CartManager {
  static final List<CartItem> items = [
    CartItem(
      id: "cart_1",
      title: "Buku Teologi Kontekstual Maluku",
      seller: "Penerbit Literasi IAKN",
      category: "Buku/Ilmiah",
      variant: "Edisi Cetak 2026 (Hardcover)",
      price: 85000,
      icon: Icons.menu_book,
      iconColor: Colors.blue,
      quantity: 1,
      isSelected: true,
    ),
    CartItem(
      id: "cart_2",
      title: "Hoodie Dies Natalis IAKN Ke-25",
      seller: "Koperasi Mahasiswa IAKN",
      category: "Merchandise",
      variant: "Warna: Biru Navy • Ukuran: L",
      price: 99000,
      icon: Icons.checkroom,
      iconColor: Colors.indigo,
      quantity: 1,
      isSelected: true,
    ),
    CartItem(
      id: "cart_3",
      title: "Miniatur Tifa Khas Maluku Orisinal",
      seller: "Sanggar Seni & Kriya Kampus",
      category: "Kriya Seni",
      variant: "Kayu Ukir Ambon 20cm",
      price: 50000,
      icon: Icons.music_note,
      iconColor: Colors.deepOrange,
      quantity: 2,
      isSelected: true,
    ),
  ];

  static void addItem({
    required String title,
    required String seller,
    required String category,
    required int price,
    required IconData icon,
    required Color iconColor,
    String? variant,
  }) {
    final existingIndex = items.indexWhere(
      (item) => item.title.trim().toLowerCase() == title.trim().toLowerCase(),
    );
    if (existingIndex >= 0) {
      items[existingIndex].quantity += 1;
    } else {
      items.add(
        CartItem(
          id: "cart_${DateTime.now().millisecondsSinceEpoch}",
          title: title,
          seller: seller,
          category: category,
          variant: variant ?? "Standar",
          price: price,
          icon: icon,
          iconColor: iconColor,
          quantity: 1,
          isSelected: true,
        ),
      );
    }
  }

  static int get itemCount => items.length;
}

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  final Color primaryBlue = const Color(0xFF0000FF);
  final Color darkBlue = const Color(0xFF00008B);

  // Voucher state
  bool _voucherApplied = true;
  final double _discountPercent = 0.35; // 35% Dies Natalis Discount

  // Delivery option: 0 = Ambil di Kampus, 1 = Antar Fakultas, 2 = Kurir Luar Kampus
  int _deliveryOption = 0;
  final List<Map<String, dynamic>> _deliveryOptions = [
    {
      "title": "Ambil di Auditorium / Koperasi",
      "desc": "Gratis • Tersedia jam kerja kampus",
      "price": 0,
      "icon": Icons.storefront,
    },
    {
      "title": "Antar ke Fakultas / Ruang Kuliah",
      "desc": "Gratis • Kurir mahasiswa IAKN",
      "price": 0,
      "icon": Icons.school,
    },
    {
      "title": "Pengiriman Luar Kampus (Ambon & Sekitar)",
      "desc": "1-2 Hari kerja",
      "price": 15000,
      "icon": Icons.local_shipping,
    },
  ];

  // References the shared CartManager items list
  List<CartItem> get _cartItems => CartManager.items;

  String _formatRupiah(int amount) {
    String str = amount.toString();
    return "Rp ${str.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  bool get _isAllSelected =>
      _cartItems.isNotEmpty && _cartItems.every((item) => item.isSelected);

  int get _selectedCount =>
      _cartItems.where((item) => item.isSelected).length;

  int get _subtotal {
    int sum = 0;
    for (var item in _cartItems) {
      if (item.isSelected) {
        sum += item.price * item.quantity;
      }
    }
    return sum;
  }

  int get _discountAmount {
    if (!_voucherApplied || _selectedCount == 0) return 0;
    return (_subtotal * _discountPercent).round();
  }

  int get _shippingCost {
    if (_selectedCount == 0) return 0;
    return _deliveryOptions[_deliveryOption]["price"] as int;
  }

  int get _totalPayment {
    if (_selectedCount == 0) return 0;
    int total = _subtotal - _discountAmount + _shippingCost;
    return total < 0 ? 0 : total;
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      final newValue = value ?? false;
      for (var item in _cartItems) {
        item.isSelected = newValue;
      }
    });
  }

  void _updateQuantity(CartItem item, int delta) {
    setState(() {
      final newQty = item.quantity + delta;
      if (newQty > 0) {
        item.quantity = newQty;
      } else {
        _confirmDeleteItem(item);
      }
    });
  }

  void _confirmDeleteItem(CartItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text("Hapus Barang?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("Apakah Anda yakin ingin menghapus '${item.title}' dari keranjang belanja?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              final removedItem = item;
              final index = _cartItems.indexOf(item);
              setState(() {
                _cartItems.remove(item);
              });
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${removedItem.title} dihapus dari keranjang."),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: "Batal",
                    textColor: Colors.yellowAccent,
                    onPressed: () {
                      setState(() {
                        _cartItems.insert(index, removedItem);
                      });
                    },
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _deleteSelectedItems() {
    if (_selectedCount == 0) {
      ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada produk yang dipilih."),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep, color: Colors.red),
            SizedBox(width: 8),
            Text("Hapus Produk Terpilih?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("Hapus $_selectedCount produk terpilih dari keranjang belanja Anda?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _cartItems.removeWhere((item) => item.isSelected);
              });
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Produk terpilih berhasil dihapus."),
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog() {
    if (_selectedCount == 0) {
      ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih minimal satu produk untuk melakukan checkout."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Konfirmasi Pesanan",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "$_selectedCount Barang",
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Alamat / Tempat Pengambilan
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Lokasi Penyerahan / Alamat",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _deliveryOptions[_deliveryOption]["title"] as String,
                                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "IAKN Ambon • Jl. Dr. J. Leimena, Halong, Baguala",
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Rincian Pembayaran
                    const Text(
                      "Rincian Pembayaran",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow("Total Harga ($_selectedCount Barang)", _formatRupiah(_subtotal)),
                    if (_voucherApplied)
                      _buildSummaryRow(
                        "Diskon Dies Natalis 35%",
                        "- ${_formatRupiah(_discountAmount)}",
                        valueColor: Colors.green.shade700,
                      ),
                    _buildSummaryRow(
                      "Biaya Penyerahan/Ongkir",
                      _shippingCost == 0 ? "GRATIS" : _formatRupiah(_shippingCost),
                      valueColor: _shippingCost == 0 ? Colors.green.shade700 : null,
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Tagihan",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          _formatRupiah(_totalPayment),
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Metode Pembayaran IAKN
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: darkBlue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkBlue.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: darkBlue, size: 22),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Metode Bayar: QRIS / Saldo Mahasiswa",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(
                                  "Bisa bayar via Mobile Banking & Dompet Digital",
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle, color: primaryBlue, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showSuccessOrderDialog();
                        },
                        child: const Text(
                          "Bayar Sekarang",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessOrderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              "Pesanan Berhasil Dibuat!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Kode Pesanan: #IKN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}\nSilakan ambil pesanan Anda atau pantau status di menu Notifikasi.",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _cartItems.removeWhere((item) => item.isSelected);
                  });
                },
                child: const Text(
                  "Selesai & Lanjut Belanja",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: darkBlue,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 16,
            bottom: 12,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "KERANJANG BELANJA",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${_cartItems.length} produk tersimpan",
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (_cartItems.isNotEmpty)
                IconButton(
                  tooltip: "Hapus produk terpilih",
                  icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                  onPressed: _deleteSelectedItems,
                ),
            ],
          ),
        ),
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutBottomBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove_shopping_cart_outlined,
                size: 54,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Keranjang Masih Kosong",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Yuk, jelajahi karya orisinal civitas akademika, buku teologi, merchandise, dan kreasi mahasiswa IAKN Ambon!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdukScreen()),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              label: const Text(
                "Mulai Belanja",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // 1. Campus Delivery / Pick-up Info Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryBlue.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.verified, color: primaryBlue, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gratis Ambil di Kampus IAKN Ambon",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      "Bisa diambil langsung di Auditorium atau Ruang Koperasi.",
                      style: TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 2. Select All Header Row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isAllSelected,
                  activeColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: _toggleSelectAll,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _toggleSelectAll(!_isAllSelected),
                child: const Text(
                  "Pilih Semua",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const Spacer(),
              Text(
                "$_selectedCount dari ${_cartItems.length} dipilih",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),

        // 3. Cart Items List
        ..._cartItems.map((item) => _buildCartItemCard(item)),

        // 4. Voucher & Promo Box
        _buildVoucherSection(),

        // 5. Opsi Pengambilan / Penyerahan
        _buildDeliverySection(),

        // 6. Ringkasan Pesanan Ringkas
        _buildOrderSummaryCard(),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isSelected ? primaryBlue.withValues(alpha: 0.3) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toko / Unit Penjual
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: item.isSelected,
                  activeColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) {
                    setState(() {
                      item.isSelected = val ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.storefront_outlined, size: 16, color: darkBlue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.seller,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: darkBlue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                tooltip: "Hapus item",
                onPressed: () => _confirmDeleteItem(item),
              ),
            ],
          ),
          const Divider(height: 16),
          // Info Produk
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Box
              Stack(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: item.iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(item.icon, size: 36, color: item.iconColor),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Detail Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.variant != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.variant!,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Baris Harga & Pengatur Kuantitas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatRupiah(item.price),
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        // Kontrol Qty
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => _updateQuantity(item, -1),
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Icon(
                                    item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                                    size: 16,
                                    color: item.quantity == 1 ? Colors.red : Colors.black87,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "${item.quantity}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => _updateQuantity(item, 1),
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: const Icon(Icons.add, size: 16, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_offer, color: Colors.amber.shade800, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Voucher Dies Natalis 35%",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Text(
                        "HEMAT 35%",
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                      ),
                    ),
                  ],
                ),
                Text(
                  _voucherApplied ? "Voucher diskon aktif diterapkan" : "Gunakan voucher untuk hemat lebih banyak",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _voucherApplied = !_voucherApplied;
              });
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _voucherApplied ? "Voucher Diskon 35% diaktifkan!" : "Voucher diskon dilepas.",
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              _voucherApplied ? "Lepas" : "Pakai",
              style: TextStyle(
                color: _voucherApplied ? Colors.red : primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.directions_bike, size: 18, color: Colors.black87),
              SizedBox(width: 6),
              Text(
                "Metode Pengambilan & Penyerahan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(_deliveryOptions.length, (idx) {
            final opt = _deliveryOptions[idx];
            final isSelected = _deliveryOption == idx;
            return InkWell(
              onTap: () {
                setState(() {
                  _deliveryOption = idx;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryBlue.withValues(alpha: 0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? primaryBlue : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      opt["icon"] as IconData,
                      size: 20,
                      color: isSelected ? primaryBlue : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt["title"] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? primaryBlue : Colors.black87,
                            ),
                          ),
                          Text(
                            opt["desc"] as String,
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      (opt["price"] as int) == 0 ? "Gratis" : _formatRupiah(opt["price"] as int),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: (opt["price"] as int) == 0 ? Colors.green.shade700 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Belanja",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 10),
          _buildSummaryRow("Total Harga ($_selectedCount Produk)", _formatRupiah(_subtotal)),
          if (_voucherApplied && _selectedCount > 0)
            _buildSummaryRow(
              "Diskon Voucher (35%)",
              "- ${_formatRupiah(_discountAmount)}",
              valueColor: Colors.green.shade700,
            ),
          _buildSummaryRow(
            "Ongkos Kirim",
            _shippingCost == 0 ? "GRATIS" : _formatRupiah(_shippingCost),
            valueColor: _shippingCost == 0 ? Colors.green.shade700 : null,
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                _formatRupiah(_totalPayment),
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Checkbox Semua
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isAllSelected,
                    activeColor: primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: _toggleSelectAll,
                  ),
                ),
                const SizedBox(width: 4),
                const Text("Semua", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            // Info Total
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Total Tagihan:", style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text(
                  _formatRupiah(_totalPayment),
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (_voucherApplied && _discountAmount > 0)
                  Text(
                    "Hemat ${_formatRupiah(_discountAmount)}",
                    style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Tombol Checkout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedCount > 0 ? primaryBlue : Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _showCheckoutDialog,
              child: Text(
                "Checkout ($_selectedCount)",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

