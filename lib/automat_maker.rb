require_relative 'modules/DFA.rb'
# Bu otomatın tasarımı ve tasarımın hakları Hanne Yazbahar'a aittir
automat = DFA.new(:start => :q0, :end => [:q2,:q4,:q5,:q7,:q8,:q9,:q10,:q11,:q12,:q13,:q14,:q15,:q16,:q17,:q18,:q19,:q21,:q22,:q23,:q25,:q26],
  :transition =>
  { :q0 => {:'01' => :q1, :'110' => :q2, :'10' => :q3, :'101' => :q4, :'011' => :q5, :'0' => :q6, :'1011' => :q7, :'1101' => :q7, },
    :q1 => {:'10' => :q8, :'101' => :q9, :'1011' => :q10},
    :q2 => {:'0' => :q11, :'10' => :q12, :'01' => :q13, :'101' => :q14, :'1011' => :q15},
    :q3 => {:'0' => :q16, :'10' => :q17, :'01' => :q18, :'101' => :q9, :'011' => :q19, :'1011' => :q10},
    :q4 => {:'10' => :q20, :'101' => :q21, :'1011' => :q19},
    :q5 => {:'10' => :q22, :'101' => :q10, :'1011' => :q15},
    :q6 => {:'10' => :q23, :'01' => :q21, :'101' => :q7, :'0' => :q24, :'011' => :q15, :'1011' => :q22},
    :q7 => {:'10' => :q14, :'101' => :q21, :'1011' => :q15},
    :q8 => {:'0' => :q9, :'10' => :q25, :'01' => :q21, :'101' => :q21, :'011' => :q15, :'1011' => :q19},
    :q9 => {:'10' => :q21, :'101' => :q19, :'1011' => :q15},
    :q10 => {:'10' => :q19, :'101' => :q15},
    :q11 => {:'10' => :q13, :'101' => :q15, :'1011' => :q15},
    :q12 => {:'0' => :q13, :'10' => :q21, :'01' => :q21, :'101' => :q19, :'1011' => :q15},
    :q13 => {:'101' => :q15},
    :q14 => {:'10' => :q19, :'101' => :q15, :'1011' => :q15},
    :q15 => {'' => :q15},
    :q16 => {:'10' => :q9, :'01' => :q15, :'101' => :q10, :'1011' => :q21},
    :q17 => {:'0' => :q9, :'10' => :q20, :'01' => :q10, :'101' => :q21, :'011' => :q21, :'1011' => :q19},
    :q18 => {:'10' => :q10, :'101' => :q21},
    :q19 => {:'10' => :q15},
    :q20 => {:'0' => :q21, :'10' => :q19, :'01' => :q19, :'101' => :q15, :'011' => :q15, :'1011' => :q15},
    :q21 => {:'10' => :q15, :'101' => :q15},
    :q22 => {:'10' => :q21, :'101' => :q19},
    :q23 => {:'0' => :q7, :'10' => :q26, :'01' => :q21, :'101' => :q14, :'011' => :q13, :'1011' => :q21},
    :q24 => {:'10' => :q21, :'101' => :q15},
    :q25 => {:'0' => :q13, :'10' => :q19, :'01' => :q19, :'101' => :q15, :'011' => :q15, :'1011' => :q15},
    :q26 => {:'0' => :q10, :'10' => :q21, :'01' => :q13, :'101' => :q19, :'011' => :q15, :'1011' => :q15},
  }
)
open('./marshalled_files/automat.marshalled', 'w') { |f| f.puts Marshal.dump(automat) }
