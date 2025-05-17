from django.shortcuts import render
from django import forms

# 物件情報フォーム
class EstimateForm(forms.Form):
    area = forms.FloatField(label='専有面積（㎡）', min_value=0)
    age = forms.IntegerField(label='築年数（年）', min_value=0)
    distance = forms.FloatField(label='最寄駅までの距離（分）', min_value=0)

def estimate_view(request):
    result = None
    if request.method == 'POST':
        form = EstimateForm(request.POST)
        if form.is_valid():
            area = form.cleaned_data['area']
            age = form.cleaned_data['age']
            distance = form.cleaned_data['distance']

            # 💡 ダミーの査定ロジック（後でモデルに置き換え）
            estimated_price = (area * 3000) - (age * 1000) - (distance * 500)
            result = f"{estimated_price:,.0f} 円"
    else:
        form = EstimateForm()

    return render(request, 'estimator/estimate.html', {'form': form, 'result': result})

