=====================    4K Procedual GFX Monitor  ========================
=====================      kioku @ System K 2009   ========================
Ver. 0.1
2009.02.01

������͂ȂɁH
�ŋ߂��܂��ŔM��demoscene�i���K�f���j�ł�
4KB ProcedualGfx�i�v���V�[�W�����O���t�B�b�N�X�j�𐻍삷�邽�߂֗̕��c�[���ł��B
GLSL���g�����v���V�[�W�����O���t�B�b�N�X�̍쐬���ȒP�ɂł��܂��B
������v���V�[�W�����O���t�B�b�N�X�̓X�^���h�A���[���œ��삷��\�[�X�t�@�C���ɏo�͂���܂��B
������VisualStudio�̃v���W�F�N�g�𗘗p���邱�ƂŁA�ȒP��EXE�ɂ��邱�Ƃ��ł��܂��B
�܂��ALink���Ɉ��k����crinkler�𗘗p���邱�ƂŁA�{�i�I��4KB ProcedualGfx�̎��s�t�@�C����
�쐬���邱�Ƃ��ł��܂��B


������
���̃\�t�g�͎��GLSL��p����4KB ProcedualGfx�̊J����e�Ղɂ��܂��B
GLSL�̕K�v�ȃR�[�h�������A�c�[������r���h�p�̃\�[�X�t�@�C�����G�N�X�|�[�g����܂��B


�����e��
4kgfxmon.exe           ���̃\�t�g�E�F�A�̖{��
4kgfxmon_safe.exe      �񈳏k�o�[�W�����i�E�C���X�\�t�g�Ɉ�����������͂�������j
readme.txt             ���̃e�L�X�g�t�@�C��
vs.glsl                �N�����ɓǂ܂��vertexshader�v���O����
fs.glsl                �N�����ɓǂ܂��fragmentshader�v���O����
template.txt           �\�[�X�G�N�X�|�[�g�p�̌��\�[�X�e���v���[�g
4kgfx.sln              �X�^���h�A�����v���O�����r���h�p��VisualStudio2005�\�����[�V�����t�@�C��
4kgfx.vcproj           �X�^���h�A�����v���O�����r���h�p��VisualC++�v���W�F�N�g�t�@�C��
kickCrinkler.bat       �X�^���h�A�����v���O�����r���h�p��crinkler�L�b�N�o�b�`�t�@�C��
sample�t�H���_         �������̃T���v�������^�i�R�s�[���Ă����Ă��������j


���p�ӂ������
�G�f�B�^
GLSL�̒m��
VisualStudio (�Ȃ����Express Edition���_�E�����[�h���Ă���
 �������͂��̑���C++�R���p�C��
crinkler(�_�E�����[�h���Ă���




���g����
���ŏ��ɁE�E�E
4kgfxmon�ł̓v���r���[�E�C���h�E�S�̂�1����4�p�|���S����`�悵�܂��B
���̃|���S����"vs.glsl"��"fs.glsl"��������Vertex/Fragment Program���g���ĕ`�悵�܂��B
���������ꂾ���ł����A���낢��ȑn�ӍH�v�Ō��\���낢��Ȃ��Ƃ��ł��܂��B
sample�t�H���_�̒��ɂ���t�@�C�����R�s�[���ăv���r���[���Ă݂Ă��������B


���v���r���[���Ă݂�
4kgfxmon.exe���N��������Ǝ����I�Ɏ��s�t�@�C���Ɠ����t�H���_�ɂ���
"vs.glsl"��"fs.glsl"�t�@�C����ǂݍ��݁A
���ꂼ��VertexProgram��FragmentProgram���쐬���A���s���܂��B
"vs.glsl"��"fs.glsl"�̃t�@�C�����Ȃ��ꍇ��Program���쐬����Ȃ��̂�
�G���[���\������A�����v���r���[����܂���B


���ҏW���Ă݂�
4kgfxmon���N�����Ă���Ԃ�"vs.glsl"��"fs.glsl"�t�@�C���̍X�V���Ď����܂��B
"vs.glsl"��"fs.glsl"�t�@�C���̓��e��ύX���u�ۑ��v����ƁA
4kgfxmon�̓t�@�C�����ēǂݍ��݂����ꂼ���Program�̃����[�h���s���܂��B
�܂�Vertex/FragmentProgram�̃\�[�X��ҏW�������ʂ�������4kgfxmon��Ŏ��s����܂��B
�\�[�X�v���O�����ɃG���[������ꍇ�͉�ʂ����ɂȂ�A��ʂɃG���[���\������܂��B
�ĂсA�G���[���Ȃ��Ȃ����v���O������4kgfxmon��Ŏ��s����܂��B


���G�N�X�|�[�g���Ă݂�
�G���[���Ȃ��v���O�������ł�����Acpp�\�[�X�t�@�C���ɃG�N�X�|�[�g���Ă݂܂��B
4kgfxmon�̃v���r���[�E�C���h�E��ŉE�N���b�N������ƃ��j���[���ł܂��B
���j���[����"Export..."��I��ł��������B
���s�t�@�C���Ɠ����t�H���_��template.cpp�t�@�C�����쐬����܂��B
�o�͂����\�[�X��template.txt���x�[�X��GLSL�̃\�[�X���}������܂��B
GLSL�\�[�X���̃R�����g�Ȃǂ̓G�N�X�|�[�g�ɂ͍폜����܂��B
�܂��^�u����s��s�v�ȃX�y�[�X�̓T�C�Y�팸�̂��߂ɍ폜����l�߂��܂��B
template.txt�͍D���Ȃ悤�ɕҏW���ė��p���Ă��������B
template.txt���Ȃ���cpp�̃\�[�X��������Əo�͂���Ȃ��̂ŋC�����Ă��������B


���X�^���h�A���[���v���O����������
�X�^���h�A���[���œ����v���O���������ꍇ�A�܂��G�N�X�|�[�g���s��template.cpp��
�o�͂���Ă��邱�Ƃ��m�F���Ă��������B
������ƃG�N�X�|�[�g����Ă��邱�Ƃ��m�F���A4kgfx.sln��VisualStudio�ŊJ���Ă��������B
���̂܂܃r���h���邱�ƂŃX�^���h�A���[���̃v���O�������쐬���邱�Ƃ��ł��܂��B
�iVisualStudio2005/2008�Ŋm�F�j


��Crinkler���g���ď������X�^���h�A���[���v���O����������
crinkler [ http://www.crinkler.net/ ] ���_�E�����[�h���āA
4kgfx��VisualStudio�̃v���W�F�N�g�Ɠ����t�H���_��crinkler.exe������Ă��������B
kickCrinkler.bat�����邱�Ƃ��m�F���Ă��������B
4kgfx.sln��VisualStudio�ŊJ���Ă��������B
�\���}�l�[�W������"useCrinkler"��I�����āA�r���h���Ă��������B
template.cpp��template.obj�ɃR���p�C��������ŁA
kickCrinkler.bat����Crinkler���g���Ă�link���s���܂��B
���t�H���_��compless.exe���쐬����Ă���ΐ����ł��B
(Crinkler 1.1a�Ŋm�F)


��VisualStudio����Ȃ�C++�R���p�C���ł���΂�
���߂��Ă܂��񂪁Atemplate.cpp��template.obj�ɂ���
���Ƃ�kickCrinkler.bat�����΁A�ł���悤�ȋC�����܂��B
template.txt��ҏW����΁AWindows�ł����łȂ��A
linux�ł�mac�ł̃v���V�[�W�����O���t�B�b�N�X���쐬�\�ɂȂ�܂��B


�����̑��@�\
�v���r���[�E�C���h�E�ŉE�N���b�N����ƃ��j���[���ł܂��B

Always On Top       -    ��Ɏ�O
4:3                 -    ���T�C�Y���̃E�C���h�E�̏c����� 4: 3�ɌŒ肵�܂�
16:9                -    ���T�C�Y���̃E�C���h�E�̏c�����16: 9�ɌŒ肵�܂�
16:10               -    ���T�C�Y���̃E�C���h�E�̏c�����16:10�ɌŒ肵�܂�
calc RenderTime...  -    10��`�悵���ϒl����`��ɂ����鎞�Ԃ��v�Z���܂��i�����܂Ŗڈ��ł�
Export...           -    template.cpp�̃\�[�X�t�@�C�����G�N�X�|�[�g���܂�


�����C�Z���X�Ȃ�
������t���[�E�F�A�ł��B���p�^�񏤗p�ł̗��p�͎��ȐӔC�łǂ����B
���̃\�t�g�E�F�A�̏o�͌��ʂł����Ȃ��Q���������Ƃ��Ă��ӔC�𕉂��܂���B
���̃\�t�g�𗘗p���č��ꂽ���ʕ��͗��p�҂̒��앨�ɂȂ�܂��B
4kgfxmon�ƃT���v���\�[�X�̒��쌠��kioku/System K�ɂ���܂��B
�������A�t������T���v���\�[�X�̃R�[�h�͉��ρE���p���R�ł��B
�s���ȓ_�̓��[�������������B[kioku@sys-k.net]


���o�O�𔭌����܂����I����ȋ@�\���₵�āI�t�@�����^�[�I
[kioku@sys-k.net]�܂łǂ���


������
�m�C�Y�e�N�X�`�����͂Ƃ��~�������Ȃ��Ƃ��������Ă܂��B���Ƃ͎��ԕϐ��Ƃ��B
�d�l�����ߐ؂�Ȃ������̂ŁA����͕ۗ����܂����B
���ƁA�C����������mac�ł�4kgfxmon�����낤���Ƃł��l���Ă܂��B


�����Ƃ���
�ŋ߈ꕔ�ł͂Ȃɂ��ƔM��4k Procedual Gfx�ł����A
�ӊO�Ƀn�[�h���͒Ⴂ�̂ŃR�����C��demoscene�ɋ��������l���������炤�ꂵ���ł��B
���₟����ɂ��Ă��V�F�[�_�̓e�L�X�g���킷�����ł��낢��ł����Ⴄ�̂�
4k�Ƃ��ɂ͂����Ă��ł��˂��B�ł�܂��B
.kioku / System K




