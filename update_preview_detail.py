with open('preview/index.html', 'r', encoding='utf-8') as f:
    c = f.read()

# 1. Add Detail Produk CSS
detail_css = """
    /* Detail Produk Screen */
    #screen-detail-produk {
      background: #f8fafc;
      display: flex;
      flex-direction: column;
      position: relative;
      height: 100%;
    }
    .detail-hero-box {
      height: 220px;
      width: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
    }
    .detail-tag-badge {
      position: absolute;
      top: 14px;
      left: 14px;
      background: rgba(255, 255, 255, 0.95);
      padding: 4px 10px;
      border-radius: 6px;
      font-size: 11px;
      font-weight: 700;
      color: var(--primary-blue);
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
    }
    .detail-discount-badge {
      position: absolute;
      top: 14px;
      right: 14px;
      background: #ef4444;
      color: #fff;
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 11px;
      font-weight: 700;
    }
    .detail-card-white {
      background: #fff;
      padding: 16px;
      margin-bottom: 8px;
    }
    .spec-table-row {
      display: flex;
      font-size: 12px;
      padding: 5px 0;
      border-bottom: 1px solid #f1f5f9;
    }
    .spec-table-label {
      width: 110px;
      color: #64748b;
    }
    .spec-table-val {
      flex: 1;
      font-weight: 600;
      color: #0f172a;
    }
    .detail-bottom-bar {
      background: #fff;
      border-top: 1px solid #e2e8f0;
      padding: 10px 16px;
      display: flex;
      align-items: center;
      gap: 10px;
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      box-shadow: 0 -4px 14px rgba(0, 0, 0, 0.06);
      z-index: 20;
    }
"""

c = c.replace("</style>", detail_css + "\n  </style>")

# 2. Add Detail button in quick-screens-bar
old_quick_bar = '<button class="quick-pill" onclick="navigateTo(\'screen-keranjang\')" style="background: rgba(0, 0, 255, 0.3); color: white; font-weight: bold;">🛒 Keranjang</button>'
new_quick_bar = '<button class="quick-pill" onclick="navigateTo(\'screen-keranjang\')" style="background: rgba(0, 0, 255, 0.3); color: white; font-weight: bold;">🛒 Keranjang</button>\n    <button class="quick-pill" onclick="openProductDetail(\'prod_1\')">Detail Produk</button>'
assert old_quick_bar in c, "old_quick_bar not found"
c = c.replace(old_quick_bar, new_quick_bar, 1)

# 3. Add Screen Detail Produk HTML inside screen-content
detail_screen_html = """      <!-- 8. DETAIL PRODUK SCREEN -->
      <div id="screen-detail-produk" class="screen">
        <!-- Top App Bar -->
        <div class="cart-header" style="background: var(--dark-blue);">
          <button class="btn-back" onclick="navigateTo('screen-home')">
            <span class="material-icons">arrow_back</span>
          </button>
          <div class="cart-header-title">
            <h3>DETAIL PRODUK</h3>
            <p>IAKN Commerce Official</p>
          </div>
          <button class="btn-back" onclick="toggleDetailFav(this)" title="Favorit">
            <span class="material-icons" id="detail-fav-icon">favorite_border</span>
          </button>
          <button class="btn-back" onclick="navigateTo('screen-keranjang')" title="Buka Keranjang">
            <div style="position: relative;">
              <span class="material-icons" style="font-size: 24px;">shopping_cart</span>
              <div class="cart-badge" style="top: -6px; right: -8px; width: 15px; height: 15px; font-size: 9px;">3</div>
            </div>
          </button>
        </div>

        <!-- Scrollable Detail Body -->
        <div class="cart-body" style="padding-bottom: 80px;">
          <!-- Hero Image Box -->
          <div class="detail-hero-box" id="detail-hero-box" style="background: linear-gradient(135deg, #fef08a 0%, #fde047 100%);">
            <span class="material-icons" id="detail-hero-icon" style="font-size: 100px; color: #854d0e;">auto_stories</span>
            <div class="detail-tag-badge" id="detail-tag-badge">Buku Ilmiah</div>
            <div class="detail-discount-badge" id="detail-discount-badge" style="display: none;">-40%</div>
          </div>

          <!-- Price & Title Section -->
          <div class="detail-card-white">
            <div style="display: flex; align-items: baseline; gap: 8px;">
              <span id="detail-price" style="font-size: 22px; font-weight: 800; color: var(--primary-blue);">Rp 85.000</span>
              <span id="detail-old-price" style="font-size: 13px; color: #94a3b8; text-decoration: line-through; display: none;">165rb</span>
            </div>
            <h2 id="detail-title" style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 8px 0 6px; line-height: 1.3;">
              Antropologi Musik Maluku &amp; Nusantara
            </h2>
            <div style="display: flex; align-items: center; gap: 8px; font-size: 12px; color: #64748b;">
              <div style="display: flex; align-items: center; gap: 2px;">
                <span class="material-icons" style="color: #f59e0b; font-size: 16px;">star</span>
                <strong id="detail-rating" style="color: #0f172a;">4.9</strong>
                <span id="detail-reviews">(120 ulasan)</span>
              </div>
              <span>•</span>
              <span id="detail-sold">250+ Terjual</span>
              <span>•</span>
              <span style="color: #16a34a; font-weight: 600;">Stok Tersedia</span>
            </div>
          </div>

          <!-- Seller Info Card -->
          <div class="detail-card-white" style="display: flex; align-items: center; gap: 12px;">
            <div style="width: 44px; height: 44px; border-radius: 50%; background: rgba(0, 0, 139, 0.1); display: flex; align-items: center; justify-content: center; color: var(--dark-blue);">
              <span class="material-icons" style="font-size: 24px;">school</span>
            </div>
            <div style="flex: 1;">
              <div style="display: flex; align-items: center; gap: 4px;">
                <strong id="detail-seller" style="font-size: 13px; color: #0f172a;">Oleh: Prodi Musik Gereja</strong>
                <span class="material-icons" style="font-size: 14px; color: #3b82f6;">verified</span>
              </div>
              <p style="font-size: 11px; color: #64748b; margin: 2px 0 0;">Civitas Akademika IAKN Ambon</p>
            </div>
            <button class="btn-cek" onclick="showToast('Membuka profil civitas kampus')">Kunjungi</button>
          </div>

          <!-- Product Specifications -->
          <div class="detail-card-white">
            <h3 style="font-size: 13px; font-weight: 700; color: #0f172a; margin-bottom: 10px;">Spesifikasi &amp; Informasi</h3>
            <div class="spec-table-row">
              <span class="spec-table-label">Kategori</span>
              <span class="spec-table-val" id="detail-spec-cat">Buku/Ilmiah</span>
            </div>
            <div class="spec-table-row">
              <span class="spec-table-label">Kondisi</span>
              <span class="spec-table-val">Baru (Orisinal 100%)</span>
            </div>
            <div class="spec-table-row">
              <span class="spec-table-label">Penjamin Mutu</span>
              <span class="spec-table-val">Lembaga Akademik IAKN Ambon</span>
            </div>
            <div class="spec-table-row">
              <span class="spec-table-label">Pengambilan</span>
              <span class="spec-table-val" style="color: #16a34a;">Gratis di Auditorium / Koperasi</span>
            </div>
          </div>

          <!-- Product Description -->
          <div class="detail-card-white">
            <h3 style="font-size: 13px; font-weight: 700; color: #0f172a; margin-bottom: 8px;">Deskripsi Produk</h3>
            <p id="detail-description" style="font-size: 12px; line-height: 1.6; color: #334155;">
              Buku referensi ilmiah karya kolaboratif dosen dan mahasiswa Program Studi Musik Gereja IAKN Ambon. Mengulas secara mendalam kekayaan etnomusikologi, ragam nyanyian liturgi kontekstual, dan instrumen tradisional khas Maluku dalam perspektif antropologi budaya Nusantara.
            </p>
            <div class="info-banner" style="margin: 12px 0 0; background: rgba(0, 0, 255, 0.05); border: 1px solid rgba(0,0,255,0.15);">
              <span class="material-icons" style="color: var(--primary-blue); font-size: 22px;">volunteer_activism</span>
              <div class="info-banner-text">
                <p style="font-size: 11px; white-space: normal; color: #1e293b;">
                  Setiap transaksi mendukung langsung dana beasiswa dan riset kreatif mahasiswa IAKN Ambon.
                </p>
              </div>
            </div>
          </div>

          <!-- Quantity Picker -->
          <div class="detail-card-white" style="display: flex; align-items: center; justify-content: space-between;">
            <span style="font-size: 12px; font-weight: 700; color: #0f172a;">Jumlah Pembelian:</span>
            <div class="qty-control">
              <button class="qty-btn" onclick="adjustDetailQty(-1)">
                <span class="material-icons" style="font-size: 14px;">remove</span>
              </button>
              <span class="qty-num" id="detail-qty-num">1</span>
              <button class="qty-btn" onclick="adjustDetailQty(1)">
                <span class="material-icons" style="font-size: 14px;">add</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Detail Bottom Action Bar -->
        <div class="detail-bottom-bar">
          <button onclick="showToast('Membuka chat pesan kampus...')" style="background: transparent; border: 1px solid #cbd5e1; border-radius: 8px; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; cursor: pointer; color: var(--dark-blue);">
            <span class="material-icons" style="font-size: 20px;">chat_outlined</span>
          </button>
          <button onclick="addCurrentDetailToCart()" style="flex: 1; background: transparent; border: 1.5px solid var(--primary-blue); border-radius: 8px; height: 40px; font-size: 12px; font-weight: 700; color: var(--primary-blue); cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 4px;">
            <span class="material-icons" style="font-size: 18px;">add_shopping_cart</span>
            <span>+ Keranjang</span>
          </button>
          <button onclick="buyCurrentDetailNow()" style="flex: 1; background: var(--primary-blue); border: none; border-radius: 8px; height: 40px; font-size: 12px; font-weight: 700; color: #fff; cursor: pointer;">
            Beli Sekarang
          </button>
        </div>
      </div>
"""

target_end_cart = "        </div>\n      </div>\n\n    </div>\n  </div>"
replacement_detail = "        </div>\n      </div>\n\n" + detail_screen_html + "\n    </div>\n  </div>"
assert target_end_cart in c, "target_end_cart not found"
c = c.replace(target_end_cart, replacement_detail, 1)

# 4. Update product cards on Home to call openProductDetail
# Product 1
c = c.replace(
    '<!-- Product 1 -->\n            <div class="product-card">',
    '<!-- Product 1 -->\n            <div class="product-card" onclick="openProductDetail(\'prod_1\')" style="cursor: pointer;">'
)

# Product 2
c = c.replace(
    '<!-- Product 2 -->\n            <div class="product-card">',
    '<!-- Product 2 -->\n            <div class="product-card" onclick="openProductDetail(\'prod_2\')" style="cursor: pointer;">'
)

# Product 3
c = c.replace(
    '<!-- Product 3 -->\n            <div class="product-card">',
    '<!-- Product 3 -->\n            <div class="product-card" onclick="openProductDetail(\'prod_3\')" style="cursor: pointer;">'
)

# Product 4
c = c.replace(
    '<!-- Product 4 -->\n            <div class="product-card">',
    '<!-- Product 4 -->\n            <div class="product-card" onclick="openProductDetail(\'prod_4\')" style="cursor: pointer;">'
)

# In add-cart buttons on home, add event.stopPropagation() so clicking cart doesn't trigger card click
c = c.replace(
    '<button class="btn-add-cart" onclick="addProductToCartHome(\'prod_1\')">',
    '<button class="btn-add-cart" onclick="event.stopPropagation(); addProductToCartHome(\'prod_1\')">'
)
c = c.replace(
    '<button class="btn-add-cart" onclick="addProductToCartHome(\'prod_2\')">',
    '<button class="btn-add-cart" onclick="event.stopPropagation(); addProductToCartHome(\'prod_2\')">'
)
c = c.replace(
    '<button class="btn-add-cart" onclick="addProductToCartHome(\'prod_3\')">',
    '<button class="btn-add-cart" onclick="event.stopPropagation(); addProductToCartHome(\'prod_3\')">'
)
c = c.replace(
    '<button class="btn-add-cart" onclick="addProductToCartHome(\'prod_4\')">',
    '<button class="btn-add-cart" onclick="event.stopPropagation(); addProductToCartHome(\'prod_4\')">'
)

# Flash sale cards to open detail
c = c.replace(
    '<div class="flash-card" onclick="addProductToCartHome(\'prod_6\')" style="cursor: pointer;" title="Tambah ke Keranjang">',
    '<div class="flash-card" onclick="openProductDetail(\'prod_6\')" style="cursor: pointer;" title="Klik untuk lihat detail">'
)
c = c.replace(
    '<div class="flash-card" onclick="addProductToCartHome(\'prod_7\')" style="cursor: pointer;" title="Tambah ke Keranjang">',
    '<div class="flash-card" onclick="openProductDetail(\'prod_7\')" style="cursor: pointer;" title="Klik untuk lihat detail">'
)
c = c.replace(
    '<div class="flash-card" onclick="addProductToCartHome(\'prod_8\')" style="cursor: pointer;" title="Tambah ke Keranjang">',
    '<div class="flash-card" onclick="openProductDetail(\'prod_8\')" style="cursor: pointer;" title="Klik untuk lihat detail">'
)

# Search grid product card click
old_search_card_tmpl = """          filtered.forEach(p => {
            html += `
              <div class="product-card">"""

new_search_card_tmpl = """          filtered.forEach(p => {
            html += `
              <div class="product-card" onclick="openProductDetail('${p.id}')" style="cursor: pointer;">"""

assert old_search_card_tmpl in c, "old_search_card_tmpl not found"
c = c.replace(old_search_card_tmpl, new_search_card_tmpl, 1)

old_search_cart_btn = """                    <button class="btn-add-cart" onclick="addProductToCartHome('${p.id}')">"""
new_search_cart_btn = """                    <button class="btn-add-cart" onclick="event.stopPropagation(); addProductToCartHome('${p.id}')">"""
assert old_search_cart_btn in c, "old_search_cart_btn not found"
c = c.replace(old_search_cart_btn, new_search_cart_btn, 1)

# 5. Add JavaScript functions for Product Detail before </script>
detail_js = """
    // Product Detail Logic
    let currentDetailProduct = null;
    let detailQuantity = 1;
    let isDetailFavorite = false;

    const productDescriptions = {
      "prod_1": "Buku referensi ilmiah karya kolaboratif dosen dan mahasiswa Program Studi Musik Gereja IAKN Ambon. Mengulas secara mendalam kekayaan etnomusikologi, ragam nyanyian liturgi kontekstual, dan instrumen tradisional khas Maluku dalam perspektif antropologi budaya Nusantara.",
      "prod_2": "Layanan pembuatan desain visual profesional oleh tim Kreatif Lab Mahasiswa IAKN. Melayani pembuatan poster seminar, spanduk dies natalis, banner kegiatan gerejawi, brosur, serta grafis media sosial dengan revisi fleksibel dan pengerjaan kilat.",
      "prod_3": "Instrumen musik perkusi tifa tradisional khas Maluku yang dipahat langsung oleh mahasiswa seni kriya kampus. Dibuat menggunakan kayu lenggua pilihan berkepadatan tinggi dan membran kulit alami yang menghasilkan resonansi suara autentik dan kuat.",
      "prod_4": "Paket perangkat ajar edukatif interaktif rancangan Laboratorium FKIP IAKN Ambon. Dilengkapi materi cerita Alkitab anak, lagu rohani interaktif, dan lembar aktivitas kreatif ramah anak usia dini.",
      "prod_5": "Karya ilmiah unggulan dosen IAKN Ambon yang membahas integrasi nilai-nilai kearifan lokal 'Pela Gandong' dengan teologi kontekstual kontemporer dalam membina harmoni dan persaudaraan masyarakat kepulauan.",
      "prod_6": "Hoodie edisi eksklusif perayaan Dies Natalis IAKN Ambon ke-25. Dibuat dari bahan premium cotton fleece yang lembut, hangat, dan nyaman dipakai kuliah sehari-hari dengan sablon grafis logo IAKN tahan lama.",
      "prod_7": "Tumbler vacuum flask ramah lingkungan edisi Dies Natalis IAKN Ambon. Menjaga suhu air panas/dingin hingga 12 jam, dilengkapi ukiran grafir laser presisi logo kebanggaan IAKN.",
      "prod_8": "Suvenir miniatur tifa ukuran 20cm dengan ukiran etnik khas Maluku buatan tangan Sanggar Seni & Kriya Kampus. Sangat pas untuk cenderamata wisuda dan oleh-oleh tamu kehormatan.",
      "prod_9": "Layanan penerjemahan naskah ilmiah, artikel jurnal, skripsi, dan abstrak bilingual (Indonesia - Inggris) oleh tim ahli Unit Bahasa IAKN Ambon dengan akurasi tata bahasa akademis terjamin.",
      "prod_10": "Totebag kanvas tebal ramah lingkungan berhias motif tenun khas Maluku persembahan BEM IAKN Ambon. Cocok untuk membawa buku kuliah, laptop, dan perlengkapan harian.",
      "prod_11": "Gitar akustik handmade hasil rancang bangun mahasiswa Prodi Pendidikan Seni Musik IAKN Ambon. Menggunakan kayu spruce pilihan dengan intonasi nada presisi dan neck ergonomis.",
      "prod_12": "Aplikasi multimedia interaktif panduan tata ibadah dan aransemen musik liturgi digital karya Laboratorium Komputer IAKN Ambon. Dilengkapi partitur digital dan simulasi paduan suara."
    };

    function openProductDetail(prodId) {
      const prod = allHomeProducts.find(p => p.id === prodId) || allHomeProducts[0];
      currentDetailProduct = prod;
      detailQuantity = 1;
      isDetailFavorite = false;

      // Update UI elements
      const heroBox = document.getElementById('detail-hero-box');
      const heroIcon = document.getElementById('detail-hero-icon');
      const tagBadge = document.getElementById('detail-tag-badge');
      const discBadge = document.getElementById('detail-discount-badge');
      const priceEl = document.getElementById('detail-price');
      const oldPriceEl = document.getElementById('detail-old-price');
      const titleEl = document.getElementById('detail-title');
      const ratingEl = document.getElementById('detail-rating');
      const reviewsEl = document.getElementById('detail-reviews');
      const sellerEl = document.getElementById('detail-seller');
      const catEl = document.getElementById('detail-spec-cat');
      const descEl = document.getElementById('detail-description');
      const qtyNum = document.getElementById('detail-qty-num');
      const favIcon = document.getElementById('detail-fav-icon');

      if (heroBox) heroBox.style.background = prod.bg;
      if (heroIcon) {
        heroIcon.textContent = prod.icon;
        heroIcon.style.color = prod.iconColor;
      }
      if (tagBadge) tagBadge.textContent = prod.tag;
      if (priceEl) priceEl.textContent = prod.priceStr;
      if (titleEl) titleEl.textContent = prod.title;
      if (ratingEl) ratingEl.textContent = prod.rating;
      if (reviewsEl) reviewsEl.textContent = '(' + prod.reviews + ' ulasan)';
      if (sellerEl) sellerEl.textContent = prod.author;
      if (catEl) catEl.textContent = prod.category;
      if (qtyNum) qtyNum.textContent = '1';
      if (favIcon) favIcon.textContent = 'favorite_border';

      const desc = productDescriptions[prod.id] || "Produk berkualitas hasil karya civitas akademika IAKN Ambon.";
      if (descEl) descEl.textContent = desc;

      if (prod.oldPrice && oldPriceEl) {
        oldPriceEl.textContent = prod.oldPrice;
        oldPriceEl.style.display = 'inline';
      } else if (oldPriceEl) {
        oldPriceEl.style.display = 'none';
      }

      if (prod.discount && discBadge) {
        discBadge.textContent = prod.discount;
        discBadge.style.display = 'block';
      } else if (discBadge) {
        discBadge.style.display = 'none';
      }

      navigateTo('screen-detail-produk');
    }

    function adjustDetailQty(delta) {
      detailQuantity = Math.max(1, detailQuantity + delta);
      const qtyNum = document.getElementById('detail-qty-num');
      if (qtyNum) qtyNum.textContent = detailQuantity;
    }

    function toggleDetailFav(btn) {
      isDetailFavorite = !isDetailFavorite;
      const icon = document.getElementById('detail-fav-icon');
      if (icon) {
        icon.textContent = isDetailFavorite ? 'favorite' : 'favorite_border';
        icon.style.color = isDetailFavorite ? '#ef4444' : '#ffffff';
      }
      showToast(isDetailFavorite ? 'Disimpan ke daftar favorit' : 'Dihapus dari favorit');
    }

    function addCurrentDetailToCart() {
      if (!currentDetailProduct) return;
      const prod = currentDetailProduct;

      const existing = cartItems.find(item => item.title === prod.title);
      if (existing) {
        existing.qty += detailQuantity;
      } else {
        cartItems.push({
          id: Date.now(),
          title: prod.title,
          seller: prod.author,
          category: prod.category,
          variant: "Standar",
          price: prod.price,
          qty: detailQuantity,
          selected: true,
          icon: prod.icon,
          bgColor: "rgba(0, 0, 255, 0.1)",
          iconColor: prod.iconColor || "#0000FF"
        });
      }

      showToast(detailQuantity + "x '" + prod.title + "' ditambahkan ke keranjang!");
      updateCartBadgeCount();
      renderCartItems();
    }

    function buyCurrentDetailNow() {
      addCurrentDetailToCart();
      navigateTo('screen-keranjang');
    }
"""

c = c.replace("  </script>\n</body>", detail_js + "\n  </script>\n</body>")

with open('preview/index.html', 'w', encoding='utf-8') as f:
    f.write(c)

print('Updated preview/index.html with interactive Detail Produk screen successfully!')

