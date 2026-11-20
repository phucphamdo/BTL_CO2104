# Bảng trạng thái 6 lab (gợi ý để điền vào mục 5 của báo cáo)

> Đây là **đề xuất** của người soạn dựa trên các chương gốc; nhóm cần đối chiếu lại với tài liệu PSpice và sửa
> cột "Trạng thái" cho đúng thực tế (Giữ nguyên = chỉ đổi công cụ; Điều chỉnh = đổi giá trị/linh kiện nhưng giữ mục tiêu;
> Thay thế = bài tương đương mới). Cột "Sai lệch LT – MP" phải lấy từ lần chạy thật.

## Lab 1 (← Ch.1 First Project on PSpice)
| # | Bài mới (LTspice) | Trạng thái | Lệnh mô phỏng |
|---|---|---|---|
| 1 | KVL với nguồn phụ thuộc | Giữ nguyên | .op |
| 2 | Điện trở tương đương (nối tiếp/song song) | Giữ nguyên | .op |
| 3 | Điện trở tương đương và điện áp nút | Giữ nguyên | .op |
| 4 | Dòng và áp trong mạng điện trở | Giữ nguyên | .op |
| 5 | Chọn điện trở chuẩn | Điều chỉnh (thêm .param/.step) | .op, .param, .step |
| 6 | Biến đổi Y–Δ, tìm Rab | Giữ nguyên | .op |
| 7 | Biến đổi mạch, tìm Is | Giữ nguyên | .op |
| 8 | Phần tử tích cực/thụ động (1) | Điều chỉnh (vẽ phần tử chưa biết bằng hình chữ nhật) | .op |
| 9 | Phần tử tích cực/thụ động (2) | Điều chỉnh | .op |
| 10 | Tìm điện áp V | Giữ nguyên | .op |
| Adv01 | Truyền công suất cực đại | Nâng cao | .step, .dc, .meas |
| Adv02 | Chồng chập nguồn | Nâng cao | .step, .dc, .meas |

## Lab 2 (← Ch.2 Diode Circuits Analysis, mục 3.1–3.10)
| # | Bài gốc | Bài mới | Trạng thái | Lệnh mô phỏng |
|---|---|---|---|---|
| 1 | 3.1 | Mô hình diode đầy đủ | Giữ nguyên | .op, .step, .dc |
| 2 | 3.2 | Diode nối tiếp | Giữ nguyên | .op |
| 3 | 3.3 | Phân tích mạch có diode | Giữ nguyên | .op, .step |
| 4 | 3.4 | Mạch kẹp | Giữ nguyên | .op, .step |
| 5 | 3.5 | Chuyển nguồn | Giữ nguyên | .op, .step |
| 6 | 3.6 | Chỉnh lưu bán kỳ | Giữ nguyên | .tran |
| 7 | 3.7 | Chỉnh lưu cầu (biến áp) | Giữ nguyên | .tran, K |
| 8 | 3.8 | Ổn áp Zener | Giữ nguyên | .op, .step |
| 9 | 3.9 | Nguồn AC/DC (5 bước) | Giữ nguyên | .tran |
| 10 | 3.10 (LM2596) | Buck converter rời | **Thay thế** | .tran |
| Adv01 | – | Vf theo nhiệt độ | Nâng cao | .step temp, .dc, .meas |
| Adv02 | – | Gợn sóng theo tụ lọc | Nâng cao | .step param, .tran, .meas PP |

## Lab 3 (← Ch.3 BJT, 13 mục → 10 bài)
| # | Bài gốc | Bài mới | Trạng thái | Lệnh mô phỏng |
|---|---|---|---|---|
| 1 | 3.1 + 3.2 | Đặc tuyến ra và bão hoà | Điều chỉnh (gộp) | .op, .dc lồng |
| 2 | 3.3 + 3.4 | BJT khoá và lái LED | Điều chỉnh (gộp) | .op |
| 3 | 3.5 | Phân cực phân áp | Điều chỉnh | .op |
| 4 | 3.6 + 3.7 | PNP và cặp bù NPN/PNP | Điều chỉnh (gộp) | .op, .tran |
| 5 | 3.8 | NPN có điện trở emitter | Điều chỉnh | .op |
| 6 | 3.9 | Darlington | Giữ nguyên | .op |
| 7 | 3.10 | Base chung | Giữ nguyên | .op |
| 8 | 3.11 | Gương dòng | Giữ nguyên | .op, .step |
| 9 | 3.12 | Cổng NOT | Giữ nguyên | .tran |
| 10 | 3.13 (opto) | Opto mô hình hành vi | **Thay thế** | .op |
| Adv01 | – | Q-point theo β | Nâng cao | .step, .dc, .meas |
| Adv02 | – | Khuếch đại CE (đáp ứng tần số) | Nâng cao | .ac |

## Lab 4 (← Ch.5 Op-amp, 7 bài + 3 bổ sung)
| # | Bài mới | Trạng thái | Lệnh mô phỏng |
|---|---|---|---|
| 1 | Khuếch đại không đảo | Bổ sung | .op |
| 2 | Khuếch đại đảo | Bổ sung | .op |
| 3 | Voltage follower | Giữ nguyên | .op |
| 4 | Follower dòng lớn | Giữ nguyên | .op |
| 5 | Follower có độ lợi | Điều chỉnh | .op |
| 6 | Mạch cộng (đảo và không đảo) | Điều chỉnh | .op |
| 7 | Lọc thông thấp | Điều chỉnh | .ac |
| 8 | Lọc thông cao | Điều chỉnh | .ac |
| 9 | Schmitt trigger | Điều chỉnh | .tran |
| 10 | Khuếch đại vi sai | Bổ sung | .op |
| Adv01 | Giới hạn GBW | Nâng cao | .step, .ac |
| Adv02 | Lọc Sallen–Key bậc 2 | Nâng cao | .ac |

## Lab 5 (← Ch.6 FET, bổ sung cho đủ 10 bài)
| # | Bài mới | Trạng thái | Lệnh mô phỏng |
|---|---|---|---|
| 1 | Đặc tuyến ra JFET | Giữ nguyên | .dc |
| 2 | Họ đặc tuyến JFET | Giữ nguyên | .dc lồng |
| 3 | Đặc tuyến truyền đạt JFET | Bổ sung | .dc |
| 4 | JFET tự phân cực | Điều chỉnh | .op |
| 5 | JFET phân áp | Điều chỉnh | .op |
| 6 | MOSFET kênh có sẵn | Điều chỉnh (khai báo .model) | .op |
| 7 | MOSFET kênh cảm ứng – đặc tuyến | Điều chỉnh | .dc lồng |
| 8 | MOSFET kênh cảm ứng – phân cực | Bổ sung | .op |
| 9 | MOSFET làm khoá | Điều chỉnh | .tran |
| 10 | Điều khiển động cơ | Điều chỉnh | .tran, .meas |
| Adv01 | Rds(on) theo VGS | Nâng cao | .dc |
| Adv02 | Bộ nghịch đảo CMOS | Nâng cao | .dc |

## Lab 6 (← Ch.7 24 Hour Project for Midterm, 8 bài + 2 bổ sung)
| # | Bài mới | Trạng thái | Lệnh mô phỏng |
|---|---|---|---|
| 1 | Điện trở tương đương (cầu) | Điều chỉnh | .op |
| 2 | Điện trở tương đương (cầu cân bằng) | Điều chỉnh | .op |
| 3 | Mạng tam giác với nguồn dòng | Điều chỉnh | .op |
| 4 | Mạch diode 1 | Giữ nguyên | .op |
| 5 | Mạch diode 2 | Giữ nguyên | .op |
| 6 | Ổn áp Zener | Điều chỉnh | .op, .step |
| 7 | BJT vào bão hoà | Điều chỉnh | .dc |
| 8 | BJT + Zener | Giữ nguyên | .op |
| 9 | Mạch xén diode | Bổ sung | .tran, .meas |
| 10 | Ổn áp nối tiếp Zener + BJT | Bổ sung | .op, .step |
| Adv01 | Monte Carlo dung sai | Nâng cao | mc(), .step, .meas |
| Adv02 | Thevenin bằng .tf | Nâng cao | .tf |
