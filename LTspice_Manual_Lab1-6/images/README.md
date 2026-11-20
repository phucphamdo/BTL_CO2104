# Hướng dẫn cấu trúc thư mục hình ảnh (`images/`)

Thư mục này được tổ chức tinh gọn để lưu trữ toàn bộ ảnh chụp schematic và dạng sóng mô phỏng LTspice:

```
images/
├── template/          # Ảnh nền template báo cáo (chapter.png)
├── Lab1/              # Ảnh mạch & kết quả Lab 1 (lab1_guide*.png, lab1_ex*.png, lab1_adv*.png)
├── Lab2/              # Ảnh mạch & kết quả Lab 2 (lab2_guide*.png, lab2_ex*.png, lab2_adv*.png)
├── Lab3/              # Ảnh mạch & kết quả Lab 3 (lab3_guide*.png, lab3_ex*.png, lab3_adv*.png)
├── Lab4/              # Ảnh mạch & kết quả Lab 4 (lab4_guide*.png, lab4_ex*.png, lab4_adv*.png)
├── Lab5/              # Ảnh mạch & kết quả Lab 5 (lab5_guide*.png, lab5_ex*.png, lab5_adv*.png)
└── Lab6/              # Ảnh mạch & kết quả Lab 6 (lab6_guide*.png, lab6_ex*.png, lab6_adv*.png)
```

## Cách thêm ảnh vào bài:
1. Bạn có thể lưu ảnh trực tiếp vào từng folder tương ứng (`images/Lab1/`, `images/Lab2/`...) hoặc để ngay tại thư mục gốc `images/`.
2. Hệ thống LaTeX trong `manual_common.tex` đã được cấu hình tự động quét tìm ảnh ở cả `images/LabN/` lẫn `images/`.
3. Khi file ảnh tồn tại, LaTeX sẽ tự động chèn ảnh thay thế khung giữ chỗ màu cam `[Insert LTspice screenshot]`.
