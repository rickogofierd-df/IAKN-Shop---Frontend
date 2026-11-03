import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'keranjang_screen.dart';

class DetailProdukScreen extends StatefulWidget {
  final ProductItem product;

  const DetailProdukScreen({super.key, required this.product});

  @override
  State<DetailProdukScreen> createState() => _DetailProdukScreenState();
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  final Color primaryBlue = const Color(0xFF0000FF);
  final Color darkBlue = const Color(0xFF00008B);

  bool _isFavorite = false;
  int _selectedQuantity = 1;

  void _addToCart() {
    for (int i = 0; i < _selectedQuantity; i++) {
      CartManager.addItem(
        title: widget.product.title,
        seller: widget.product.author,
        category: widget.product.category,
        price: widget.product.priceInt,
        icon: widget.product.icon,
        iconColor: widget.product.iconColor,
      );
    }
    setState(() {});

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "$_selectedQuantity x '${widget.product.title}' ditambahkan ke keranjang!",
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

  void _buyNow() {
    for (int i = 0; i < _selectedQuantity; i++) {
      CartManager.addItem(
        title: widget.product.title,
        seller: widget.product.author,
        category: widget.product.category,
        price: widget.product.priceInt,
        icon: widget.product.icon,
        iconColor: widget.product.iconColor,
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KeranjangScreen()),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final prod = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: darkBlue,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 4,
            left: 8,
            right: 12,
            bottom: 8,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "Detail Produk",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.redAccent : Colors.white,
                ),
                tooltip: "Simpan Produk",
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? "Produk ditambahkan ke daftar favorit."
                            : "Produk dihapus dari daftar favorit.",
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
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
                      const Icon(Icons.shopping_cart, color: Colors.white, size: 26),
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
                            minWidth: 15,
                            minHeight: 15,
                          ),
                          child: Text(
                            "${CartManager.itemCount}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
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
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. Large Hero Image Preview
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: prod.iconColor.withValues(alpha: 0.12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    prod.icon,
                    size: 110,
                    color: prod.iconColor,
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      prod.tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: prod.tagColor,
                      ),
                    ),
                  ),
                ),
                if (prod.isFlashSale && prod.discount != null)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "FLASH SALE ${prod.discount}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 2. Price and Title Card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      prod.price,
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (prod.oldPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        prod.oldPrice!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    if (prod.discount != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          prod.discount!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  prod.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${prod.rating}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " (${prod.reviews} ulasan)",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Text("•", style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 12),
                    Text(
                      "${prod.reviews * 2}+ Terjual",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 3. Campus Seller Info Card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: darkBlue.withValues(alpha: 0.1),
                  child: Icon(Icons.school, color: darkBlue, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              prod.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Civitas Akademika IAKN Ambon",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Membuka profil toko ${prod.author}"),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text("Kunjungi", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 4. Product Specifications
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Spesifikasi & Informasi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _buildSpecRow("Kategori", prod.category),
                _buildSpecRow("Status Produk", "Tersedia (Ready Stock)"),
                _buildSpecRow("Garansi", "Garansi Orisinalitas IAKN Ambon"),
                _buildSpecRow("Pengambilan", "Gratis di Auditorium / Koperasi"),
                _buildSpecRow("Pengiriman", "Antar Kampus & Kurir Luar"),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 5. Product Description
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Deskripsi Produk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  prod.description ?? _getDefaultDescription(prod),
                  style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryBlue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryBlue.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.volunteer_activism, color: primaryBlue, size: 24),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Setiap pembelian produk ini berkontribusi langsung ke dana riset dan beasiswa prestasi mahasiswa IAKN Ambon.",
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. Quantity Picker Section
          Container(
            margin: const EdgeInsets.only(top: 8),
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Atur Jumlah Pembelian:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (_selectedQuantity > 1) {
                            setState(() {
                              _selectedQuantity--;
                            });
                          }
                        },
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "$_selectedQuantity",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedQuantity++;
                          });
                        },
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              // Chat Penjual Button
              IconButton(
                icon: Icon(Icons.chat_outlined, color: darkBlue),
                tooltip: "Chat Penjual",
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Menghubungi ${prod.author} via Pesan Kampus..."),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              // Tambah ke Keranjang
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: BorderSide(color: primaryBlue, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _addToCart,
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text(
                    "+ Keranjang",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Beli Sekarang
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _buyNow,
                  child: const Text(
                    "Beli Sekarang",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _getDefaultDescription(ProductItem prod) {
    if (prod.category == "Buku/Ilmiah") {
      return "Buku karya orisinal civitas akademika Institut Agama Kristen Negeri (IAKN) Ambon. Menghadirkan wawasan teologi kontekstual, kebudayaan lokal Maluku, dan panduan akademis yang teruji serta berbobot untuk kalangan mahasiswa, dosen, dan masyarakat umum.";
    } else if (prod.category == "Alat Musik") {
      return "Karya instrumen musik etnik Maluku yang dirancang secara detail oleh mahasiswa dan instruktur seni musik IAKN Ambon. Memadukan bahan kayu pilihan dan pengerjaan manual yang menghasilkan kualitas akustik dan keindahan visual bernilai seni tinggi.";
    } else if (prod.category == "Merchandise") {
      return "Produk cendera mata resmi IAKN Ambon edisi Dies Natalis. Dibuat dengan material berkualitas tinggi, nyaman digunakan untuk aktivitas perkuliahan sehari-hari, serta memperkuat identitas kebanggaan kampus.";
    } else if (prod.category == "Tek. Edukasi") {
      return "Media dan inovasi teknologi pembelajaran yang dikembangkan oleh laboratorium fakultas di lingkungan IAKN Ambon untuk mempermudah proses belajar mengajar yang interaktif, modern, dan bermakna.";
    } else {
      return "Layanan profesional dan produk kreatif karya mahasiswa IAKN Ambon yang siap membantu kebutuhan akademis dan kegiatan Anda dengan hasil berkualitas dan harga terjangkau.";
    }
  }
}
