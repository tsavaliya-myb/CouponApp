// lib/core/mock/mock_data.dart
//
// Dummy data displayed to non-subscribed users on the Home screen.
// Shown instead of real API data — no network calls are made.

import 'dart:math';
import 'package:couponcode/features/home/domain/entities/home_coupon_entity.dart';
import 'package:couponcode/features/home/domain/entities/nearby_seller_entity.dart';
import 'package:couponcode/core/models/category_item.dart';

const _catFood = CategoryItem(id: '1', name: 'Food', slug: 'food', iconName: 'restaurant_rounded', subtitle: 'Restaurants & more', color: '#B35227', isActive: true);
const _catCafe = CategoryItem(id: '2', name: 'Cafe', slug: 'cafe', iconName: 'coffee_rounded', subtitle: 'Coffee & drinks', color: '#2F6120', isActive: true);
const _catSalon = CategoryItem(id: '3', name: 'Salon', slug: 'salon', iconName: 'content_cut_rounded', subtitle: 'Hair & beauty', color: '#70586F', isActive: true);
const _catSpa = CategoryItem(id: '4', name: 'Spa', slug: 'spa', iconName: 'spa_rounded', subtitle: 'Relax & unwind', color: '#179156', isActive: true);
const _catTheater = CategoryItem(id: '5', name: 'Theater', slug: 'theater', iconName: 'movie_rounded', subtitle: 'Movies & shows', color: '#82A346', isActive: true);

// ─── Mock Coupons (6 items) ───────────────────────────────────────────────────

final List<HomeCouponEntity> mockCoupons = [
  HomeCouponEntity(
    id: 'mock-c-1',
    sellerId: 'mock-s-1',
    sellerName: 'Spice Garden',
    sellerArea: 'Adajan',
    category: _catFood,
    discountPercent: 20,
    couponType: 'FLAT',
    minSpend: 299,
    description: 'Get 20% off on your total bill',
    validFrom: DateTime.now().subtract(const Duration(days: 10)),
    validUntil: DateTime.now().add(const Duration(days: 30)),
    isActive: true,
    status: 'ACTIVE',
    usesRemaining: 3,
    maxUsesPerBook: 3,
  ),
  HomeCouponEntity(
    id: 'mock-c-2',
    sellerId: 'mock-s-2',
    sellerName: 'Brew & Co.',
    sellerArea: 'Vesu',
    category: _catCafe,
    discountPercent: 15,
    couponType: 'PERCENT',
    minSpend: 150,
    description: '15% off on all beverages',
    validFrom: DateTime.now().subtract(const Duration(days: 5)),
    validUntil: DateTime.now().add(const Duration(days: 35)),
    isActive: true,
    status: 'ACTIVE',
    usesRemaining: 2,
    maxUsesPerBook: 2,
  ),
  HomeCouponEntity(
    id: 'mock-c-3',
    sellerId: 'mock-s-3',
    sellerName: 'Style Studio',
    sellerArea: 'Pal',
    category: _catSalon,
    discountPercent: 30,
    couponType: 'FLAT',
    minSpend: 499,
    description: '30% off on all salon services',
    validFrom: DateTime.now().subtract(const Duration(days: 2)),
    validUntil: DateTime.now().add(const Duration(days: 40)),
    isActive: true,
    status: 'ACTIVE',
    usesRemaining: 1,
    maxUsesPerBook: 1,
  ),
  HomeCouponEntity(
    id: 'mock-c-4',
    sellerId: 'mock-s-4',
    sellerName: 'Aura Wellness',
    sellerArea: 'Citylight',
    category: _catSpa,
    discountPercent: 25,
    couponType: 'PERCENT',
    minSpend: 699,
    description: '25% off on all spa packages',
    validFrom: DateTime.now().subtract(const Duration(days: 1)),
    validUntil: DateTime.now().add(const Duration(days: 28)),
    isActive: true,
    status: 'ACTIVE',
    usesRemaining: 2,
    maxUsesPerBook: 2,
  ),
  HomeCouponEntity(
    id: 'mock-c-5',
    sellerId: 'mock-s-5',
    sellerName: 'Cinemax Prime',
    sellerArea: 'Ghod Dod Rd',
    category: _catTheater,
    discountPercent: 10,
    couponType: 'FLAT',
    minSpend: 200,
    description: 'Flat 10% off on all movie tickets',
    validFrom: DateTime.now().subtract(const Duration(days: 3)),
    validUntil: DateTime.now().add(const Duration(days: 45)),
    isActive: true,
    status: 'ACTIVE',
    usesRemaining: 4,
    maxUsesPerBook: 4,
  ),
  HomeCouponEntity(
    id: 'mock-c-6',
    sellerId: 'mock-s-6',
    sellerName: 'The Grind House',
    sellerArea: 'Piplod',
    category: _catCafe,
    discountPercent: 20,
    couponType: 'FLAT',
    minSpend: 199,
    description: '20% off on all food items',
    validFrom: DateTime.now().subtract(const Duration(days: 7)),
    validUntil: DateTime.now().add(const Duration(days: 25)),
    isActive: true,
    status: 'ACTIVE',
    usesRemaining: 3,
    maxUsesPerBook: 3,
  ),
];

// ─── Mock Sellers (6 items) ───────────────────────────────────────────────────

final List<NearbySellerEntity> mockSellers = [
  const NearbySellerEntity(
    id: 'mock-s-1',
    name: 'Spice Garden',
    category: _catFood,
    area: 'Adajan',
    lat: 21.1702,
    lng: 72.8311,
    distanceKm: 0.8,
  ),
  const NearbySellerEntity(
    id: 'mock-s-2',
    name: 'Brew & Co.',
    category: _catCafe,
    area: 'Vesu',
    lat: 21.1562,
    lng: 72.7928,
    distanceKm: 2.1,
  ),
  const NearbySellerEntity(
    id: 'mock-s-3',
    name: 'Style Studio',
    category: _catSalon,
    area: 'Pal',
    lat: 21.1690,
    lng: 72.7700,
    distanceKm: 3.4,
  ),
  const NearbySellerEntity(
    id: 'mock-s-4',
    name: 'Aura Wellness',
    category: _catSpa,
    area: 'Citylight',
    lat: 21.1490,
    lng: 72.7920,
    distanceKm: 4.0,
  ),
  const NearbySellerEntity(
    id: 'mock-s-5',
    name: 'Cinemax Prime',
    category: _catTheater,
    area: 'Ghod Dod Rd',
    lat: 21.1760,
    lng: 72.8145,
    distanceKm: 1.5,
  ),
  const NearbySellerEntity(
    id: 'mock-s-6',
    name: 'The Grind House',
    category: _catCafe,
    area: 'Piplod',
    lat: 21.1632,
    lng: 72.8053,
    distanceKm: 2.6,
  ),
];

// ─── Blurred Indices ──────────────────────────────────────────────────────────
// Picks exactly 4 random indices out of 6 to blur.
// Refreshes each session (not persisted).

List<int> _cachedBlurredIndices = [];

List<int> get blurredCouponIndices {
  if (_cachedBlurredIndices.isEmpty) {
    final all = List.generate(mockCoupons.length, (i) => i)..shuffle(Random());
    _cachedBlurredIndices = all.take(4).toList();
  }
  return _cachedBlurredIndices;
}
