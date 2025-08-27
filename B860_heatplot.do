clear
cd "D:\BaiduSyncdisk\Others\lxh\ta"


**-----------------------reference------------------------
* Ben Jann, 2019, Heat (and hexagon) plots in Stata



**---------------------------------------请先安装以下包 --------------------------------------**
** heatplot requires palettes (Jann 2018) and, in Stata 14.2 or newer, colrspace (Jann 2019a).
//ssc install  heatplot, replace
//ssc install palettes, replace
//ssc install colrspace, replace


** The fast option requires gtools (Caceres Bravo 2018).
// ssc install gtools, replace
// gtools, upgrade

**安装主题
set scheme cleanplots
graph query, schemes
ssc install cleanplots, replace
set scheme cleanplots, perm
help cleanplots
*set scheme s2color, perm //回退到stata的默认主题 

* heat plot
quietly drawnorm y x, n(10000) corr(1 .5 1) cstorage(lower) clear
heatplot y x, backfill colors(plasma) xlabel(, nogrid) ylabel(, nogrid) name(Fig1, replace)
graph export "Stata可视化-heatplot-热力图_Fig1_heatplot_王博.png", name(Fig1) as(png) width(1800) height(1600) replace

* 六边形网格 
hexplot y x, backfill colors(plasma)  xlabel(, nogrid) ylabel(, nogrid) name(Fig2, replace)
graph export "Stata可视化-heatplot-热力图_Fig2_heatplot_王博.png", name(Fig2) as(png) width(1800) height(1600) replace

**例1：双变量直方图
*使用默认参数
webuse nhanes2 ,clear
heatplot weight height , xlabel(, nogrid) ylabel(, nogrid) name(Fig3, replace)
graph export "Stata可视化-heatplot-热力图_Fig3_heatplot_王博.png", name(Fig3) as(png) width(1800) height(1600) replace


**【分辨率控制】通过 xbins(20)/ybwidth(10 30) 调整 X、Y 分箱密度
heatplot weight height, xbins(20) ybwidth(10 30) xlabel(, nogrid) ylabel(, nogrid) name(Fig4, replace)
graph export "Stata可视化-heatplot-热力图_Fig4_heatplot_王博.png", name(Fig4) as(png) width(1800) height(1600) replace


*Use counts, change color ramp, change binning, and labeling
heatplot weight height, statistic(count) color(plasma, reverse) ///
cut(1(5)@max) keylabels(, range(1)) xlabel(, nogrid) ylabel(, nogrid) name(Fig5, replace)
graph export "Stata可视化-heatplot-热力图_Fig5_heatplot_王博.png", name(Fig5) as(png) width(1800) height(1600) replace

// xbins(20)：把 X 轴（height）范围均分成 20 个箱 → X 方向 20 列格子。
// ybwidth(10 30)：把 Y 轴（weight）按箱宽 10 分箱，起点从 30 开始 → Y 方向每 10 个单位一个格子，起边界是 30。

*【六边形网格替代矩形网格】hexplot + 计数着色(statistic(count)) + 反转 plasma 配色 + 自定义分段(cuts) + 精简图例标签(keylabels)
hexplot weight height, statistic(count) color(plasma, reverse) ///
cut(1(5)@max) keylabels(, range(1)) xlabel(, nogrid) ylabel(, nogrid) name(Fig6, replace)
graph export "Stata可视化-heatplot-热力图_Fig6_heatplot_王博.png", name(Fig6) as(png) width(1800) height(1600) replace

*【六边形面积按计数缩放】size：按计数绝对值缩放六边形 + plasma 配色 + cuts 分段 + 精简图例标签(keylabels)
hexplot weight height, statistic(count) color(plasma) ///
cut(1(5)@max) keylabels(, range(1)) size xlabel(, nogrid) ///
ylabel(, nogrid) name(Fig7, replace)
graph export "Stata可视化-heatplot-热力图_Fig7_heatplot_王博.png", name(Fig7) as(png) width(1800) height(1600) replace


*【矩形面积按计数缩放】size：在 heatplot 中按计数绝对值缩放矩形网格 + plasma 配色 + cuts 分段 + 精简图例标签(keylabels)
heatplot weight height, statistic(count) color(plasma) ///
cut(1(5)@max) keylabels(, range(1)) size xlabel(, nogrid) ///
ylabel(, nogrid) name(Fig8, replace)
graph export "Stata可视化-heatplot-热力图_Fig8_heatplot_王博.png", name(Fig8) as(png) width(1800) height(1600) replace


*【叠加图层：平滑回归与置信带】addplot(lpolyci) 叠加回归线+置信带 + size 面积缩放 + plasma 配色 + cuts 分段 + 精简图例(keylabels)
hexplot weight height, statistic(count) color(plasma) ///
cut(1(5)@max) keylabels(, range(1)) size ///
addplot(lpolyci weight height, degree(1) psty(p2) lw(*1.5) ac(%50) alc(%0)) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig9, replace)
graph export "Stata可视化-heatplot-热力图_Fig9_heatplot_王博.png", name(Fig9) as(png) width(1800) height(1600) replace


**【三变量热力图—女性比例在体重×身高上的空间分布】
*Z=female（0/1，默认每格statistic(mean)=均值=比例）；X=height，Y=weight；colors(PiYG) 发散配色；cuts(0(.05)1) 按 0.05 分段；ylabel(25(25)175) 自定义刻度；xlabel/ylabel(, nogrid) 去网格线


webuse nhanes2, clear
hexplot female weight height, color(PiYG) ylabel(25(25)175) cuts(0(.05)1) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig10, replace)
graph export "Stata可视化-heatplot-热力图_Fig10_heatplot_王博.png", name(Fig10) as(png) width(1800) height(1600) replace



*【同一张图，但考虑相对频数】
*【三变量热力图（六边形）—按相对频数缩放面积】Z=女性比例；X=height，Y=weight；sizeprop 令六边形面积∝相对频数 + recenter 居中；p(lcolor(black) lwidth(vthin) lalign(center)) 黑色细描边；colors(PiYG) 发散配色；cuts(0(.05)1) 0–1 每 0.05 分段；ylabel(25(25)175) 自定义刻度；去网格线
hexplot female weight height, color(PiYG) ylabel(25(25)175) cuts(0(.05)1) ///
sizeprop recenter p(lcolor(black) lwidth(vthin) lalign(center)) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig11, replace)
graph export "Stata可视化-heatplot-热力图_Fig11_heatplot_王博.png", name(Fig11) as(png) width(1800) height(1600) replace


*不同性别人群的体质指数（BMI）分布及其与高血压的关系
*【三变量热力图—性别×BMI 与高血压比例】X=性别（xdiscrete(0.9) 离散轴）；Y=BMI（yline(18.5 25) 标出常用阈值）；Z=高血压比例（cuts(0(.05).75) 以 0–0.75、步长 0.05 分段，colors(inferno) 着色）；sizeprop + recenter 按相对频数缩放并居中；plotregion(color(gs11)) 浅灰背景；xlabel/ylabel(, nogrid) 去网格线
heatplot highbp bmi i.female, xdiscrete(0.9) yline(18.5 25) cuts(0(.05).75) ///
sizeprop recenter colors(inferno) plotregion(color(gs11)) ylabel(, nogrid) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig12, replace)
graph export "Stata可视化-heatplot-热力图_Fig12_heatplot_王博.png", name(Fig12) as(png) width(1800) height(1600) replace


* 海面温度怎么随经度、纬度和时间变化？
*statistic(asis)=直接用温度值着色；discrete(.5)=经纬度每 0.5° 一格；by(date, legend(off))=按日期分面并隐藏图例；ylabel(30(1)38)=Y 轴刻度 30–38；aspectratio(1)=正方形比例
sysuse surface, clear //(NOAA Sea Surface Temperature)
heatplot temperature longitude latitude, discrete(.5) statistic(asis) ///
by(date, legend(off)) ylabel(30(1)38) aspectratio(1) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig13, replace)
graph export "Stata可视化-heatplot-热力图_Fig13_heatplot_王博.png", name(Fig13) as(png) replace

*【六边形网格替代矩形网格】
hexplot temperature longitude latitude, discrete(.5) statistic(asis) ///
by(date, legend(off)) ylabel(30(1)38) aspectratio(1) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig14, replace)
graph export "Stata可视化-heatplot-热力图_Fig14_heatplot_王博.png", name(Fig14) as(png)  replace


**【同一张图，加入边界裁剪】
* clip：裁掉绘图区外的六边形边缘，使四周切齐
hexplot temperature longitude latitude, discrete(.5) statistic(asis) clip ///
by(date, legend(off)) ylabel(30(1)38) aspectratio(1) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig15, replace)
graph export "Stata可视化-heatplot-热力图_Fig15_heatplot_王博.png", name(Fig15) as(png) replace



**【数值的标注化呈现（marker labels）】
* values(format(%9.0f))：在每个六边形单元上叠加数值标签，显示格式设为整数
* Z=price、Y=weight、X=mpg
* 默认统计量是均值，每个六边形里显示的是该格内 price 的平均值（经 format(%9.0f) 四舍五入为整数）。
* 如果你想显示别的量，比如计数或总和，可以加：
* statistic(count) → 显示每格的样本数
* statistic(sum) → 显示每格的 Z 总和
* colors(plasma, intensity(.6)) 降低配色强度；
* legend(off) 去图例；
* aspectratio(1) 正方形比例；
* p(lc(black) lalign(center)) 调整六边形边框（黑色描边，边线对齐方式）。

quietly sysuse auto, clear
hexplot price weight mpg, values(format(%9.0f)) legend(off) aspectratio(1) ///
colors(plasma, intensity(.6)) p(lc(black) lalign(center)) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig16, replace)
graph export "Stata可视化-heatplot-热力图_Fig16_heatplot_王博.png", name(Fig16) as(png) width(1800) height(1600) replace


**相关系数矩阵
*there先构建并存储相关系数矩阵，再进行可视化绘制
quietly sysuse auto, clear
quietly correlate price mpg trunk weight length turn foreign
matrix C = r(C)
heatplot C, values(format(%9.3f)) color(hcl diverging, intensity(.6)) /// 
legend(off) aspectratio(1) xlabel(, nogrid) ylabel(, nogrid) name(Fig17, replace)
graph export "Stata可视化-heatplot-热力图_Fig17_heatplot_王博.png", name(Fig17) as(png) width(1800) height(1600) replace


* 仅绘制矩阵下三角部分
* 在可视化一个对称矩阵（如相关矩阵）时，只显示主对角线以下的元素（行索引 ≥ 列索引的那一半），上三角不画。这样做的原因与用法：
* 为何这么做？
* 相关矩阵是对称的，corr(X,Y)=corr(Y,X)。上下三角信息重复，只画下三角能去冗余、节省空间，还便于放大格子或叠加数值标签，提高可读性。
* 你可以选择是否显示主对角线（通常为 1）。在 heatplot 中：
* 只画下（上）三角并保留对角线：lower upper 
* 只画下三角并去掉对角线：lower nodiagonal
heatplot C, values(format(%9.3f)) color(hcl diverging, intensity(.6)) ///
legend(off) aspectratio(1) lower nodiagonal ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig18, replace)
graph export "Stata可视化-heatplot-热力图_Fig18_heatplot_王博.png", name(Fig18) as(png) width(1800) height(1600) replace



**空间权重矩阵

// copy http://www.stata-press.com/data/r15/homicide1990.dta .  // 示例数据
// copy http://www.stata-press.com/data/r15/homicide1990_shp.dta .

*计算空间权重矩阵（可能需要一段时间）
clear all
use homicide1990, clear //(S.Messner et al.(2000), 1990年美国南部县域的凶杀率示例数据集
spmatrix create contiguity W // 根据多边形相邻关系（contiguity）创建空间权重矩阵 W
spmatrix matafromsp W id = W // 把 spmatrix 转成 Mata 矩阵
mata mata describe W  // 查看 Mata 矩阵 W的行数、列数、总单元数等。"大约 200 万个单元"

* 基于矩阵 W 的热力图：默认设置，忽略零权重单元（drop(0)），突出非零空间邻接结构
heatplot mata(W), drop(0) aspectratio(1) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig19, replace)
graph export "Stata可视化-heatplot-热力图_Fig19_heatplot_王博.png", name(Fig19) as(png) width(1800) height(1600) replace


* 矩阵 W 的高分辨率六边形热力图
* 指把网格（分箱）划得更细：单元更小、数量更多，细节更丰富。
* 在 heatplot/hexplot 中，细粒度通常通过这些参数实现：
* bins(#)、xbins()/ybins() → 增加箱数
* xbwidth()/ybwidth()、discrete(step) → 减小箱宽/步长
* hexagon bins(100) ≈ 更细的六边形网格（比 bins(20) 细很多）。
* 取舍提醒：网格更细能显露结构，但可能让每格样本过少、图面更"碎"；
* 需要配合 levels()/cuts() 或平滑/聚合来控制可读性。
* bins(100) ：把 X 轴和 Y 轴各自划分为 100 个等宽分箱
heatplot mata(W), drop(0) aspectratio(1) hexagon bins(100) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig20, replace)
graph export "Stata可视化-heatplot-热力图_Fig20_heatplot_王博.png", name(Fig20) as(png) width(1800) height(1600) replace


* 采用 discrete 选项逐格绘制每个单元
heatplot mata(W), drop(0) aspectratio(1) discrete color(black) p(lalign(center)) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig21, replace)
graph export "Stata可视化-heatplot-热力图_Fig21_heatplot_王博.png", name(Fig21) as(png) width(1800) height(1600) replace


* *【散点呈现（scatter）】以散点标记替代色块绘制每个单元
heatplot mata(W), drop(0) aspectratio(1) discrete color(black) scatter p(ms(p)) ///
xlabel(, nogrid) ylabel(, nogrid) name(Fig22, replace)
graph export "Stata可视化-heatplot-热力图_Fig22_heatplot_王博.png", name(Fig22) as(png) width(1800) height(1600) replace
