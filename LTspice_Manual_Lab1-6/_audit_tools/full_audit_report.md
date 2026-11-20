# Full Audit Report — LTspice Manual Lab1-6
**Thời gian kiểm tra:** 2026-11-20 15:40:54  
**Thư mục:** C:\Users\HONG ANH\Documents\GitHub\BTL_CO2104\LTspice_Manual_Lab1-6

---

## Phần 1: Cấu trúc .tex theo từng Lab

| Lab | Chapter | Ex(Req) | Ex(Có) | OK | Adv(Req) | Adv(Có) | OK | Status(Req) | Status(Có) | OK | Theory | Sim | Comp | Figures | Labl/Err |
|-----|---------|---------|--------|----|----------|---------|----|-----------|-----------|----|--------|-----|------|---------|----------|| Lab 1 | Ch.1 First Project on PSpice | 10 | 10 | ✓ | 2 | 2 | ✓ | 12 | 12 | ✓ | 12 | 12 | 12 | 17 | 0 |
| Lab 2 | Ch.2 Diode Circuits | 10 | 10 | ✓ | 2 | 2 | ✓ | 12 | 12 | ✓ | 12 | 12 | 12 | 16 | 0 |
| Lab 3 | Ch.3 BJT | 10 | 10 | ✓ | 2 | 2 | ✓ | 12 | 12 | ✓ | 12 | 12 | 12 | 18 | 0 |
| Lab 4 | Ch.5 Op-amp | 10 | 10 | ✓ | 2 | 2 | ✓ | 12 | 12 | ✓ | 12 | 12 | 12 | 15 | 0 |
| Lab 5 | Ch.6 FET | 10 | 10 | ✓ | 2 | 2 | ✓ | 12 | 12 | ✓ | 12 | 12 | 12 | 14 | 0 |
| Lab 6 | Ch.7 24-Hour Project (Midterm) | 10 | 10 | ✓ | 2 | 2 | ✓ | 12 | 12 | ✓ | 12 | 12 | 12 | 12 | 0 |

---

## Phần 2: File mô phỏng .asc / .cir

| Lab | Thư mục | Yêu cầu | Tìm thấy | File thiếu |
|-----|---------|---------|----------|-----------|| Lab 1 | sim\Lab1 | 12 | 12 | - |
| Lab 2 | sim\Lab2 | 12 | 12 | - |
| Lab 3 | sim\Lab3 | 12 | 12 | - |
| Lab 4 | sim\Lab4 | 12 | 12 | - |
| Lab 5 | sim\Lab5 | 12 | 12 | - |
| Lab 6 | sim\Lab6 | 12 | 12 | - |

---

## Phần 3: Đối chiếu yêu cầu giáo viên (CO2037 Dự án 3)

| Mã | Yêu cầu | Kết quả |
|----|---------|---------|| R1 | Mỗi lab: 10 bài chính + 2 nâng cao (6×12=72 tổng) | ✓ ĐẠT |
| R2 | Mỗi bài có \\status{} phân loại (Unchanged/Modified/Replaced) | ✓ ĐẠT (72/72) |
| R3 | Cấu trúc bài: Theory + Simulation + Comparison table | ✓ ĐẠT (Theory=72, Sim=72, Comp=72) |
| R4 | Mỗi bài có hình circuit (\\labfig) | labfig=92 | includegraphics=0 ✓ |
| R5 | Đặt tên file đúng chuẩn LabN/ExNN.asc (không dùng 'Labl/') | ✓ ĐẠT |
| R6 | File mô phỏng .asc/.cir đủ (LabN/Ex01-12) | 72/72 ✓ ĐẠT |

---

## Phần 4: So sánh Lab gốc (PSpice) vs Lab mới (LTspice)

| Lab | Tài liệu gốc | Tên chương mới | Unchanged | Modified | Replaced | Adv/Added | Tổng tag |
|-----|-------------|---------------|-----------|----------|----------|-----------|----------|| Lab 1 | Ch.1 First Project on PSpice (10 Ex) | DC Circuit Analysis -- First Project on LTspice | 7 | 3 | 2 | 3 | 15 |
| Lab 2 | Ch.2 Diode Circuits (3.1–3.10) | Diode Circuits Analysis | 9 | 0 | 1 | 2 | 12 |
| Lab 3 | Ch.3 BJT (13 mục → 10 bài) | Bipolar Junction Transistor | 4 | 5 | 1 | 2 | 12 |
| Lab 4 | Ch.5 Op-amp (7 bài + 3 bổ sung) | Operational Amplifier | 2 | 5 | 0 | 5 | 12 |
| Lab 5 | Ch.6 FET (bổ sung cho đủ 10) | Field Effect Transistor | 2 | 6 | 0 | 2 | 10 |
| Lab 6 | Ch.7 24-Hour Project Midterm (8+2) | Review Laboratory: Circuits with Diodes and Transistors | 3 | 5 | 3 | 2 | 13 |

---

## Phần 5: Tổng hợp lỗi & cảnh báo

### Lỗi nghiêm trọng (phải sửa)✅ Không có lỗi nghiêm trọng

### Cảnh báo (nên kiểm tra)
✅ Không có cảnh báo

---

## Checklist nghiệm thu (trước khi nộp)

- [ ] **R1** – Đủ 72 bài (6 lab × 10 chính + 2 nâng cao)
- [ ] **R2** – Mọi bài có `\status{}` ghi rõ Unchanged / Modified / Replaced
- [ ] **R3** – Cấu trúc bắt buộc: Statement → Theory calculation → LTspice simulation → Comparison table
- [ ] **R4** – Mỗi bài có hình circuit `\labfig{}`
- [ ] **R5** – Đường dẫn file chuẩn `Lab1/Ex01.asc` (không dùng `Labl/`, `Lab3 3/`)
- [ ] **R6** – File `.asc` / `.cir` đầy đủ trong `sim\LabN\`
- [ ] **R7** – Ảnh thực tế từ LTspice (không còn placeholder `[Insert screenshot]`)
- [ ] **R8** – Bảng Comparison có cột `Error (%)` = |Lý thuyết − Mô phỏng| / Lý thuyết × 100
- [ ] **R9** – Ký hiệu toán học đúng (β, Ω, v₀, kΩ — không lẫn OCR lỗi)
- [ ] **R10** – Mục lục cập nhật số trang sau khi thêm ảnh
