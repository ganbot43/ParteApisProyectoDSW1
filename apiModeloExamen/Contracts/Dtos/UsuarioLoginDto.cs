namespace apiModeloExamen.Contracts.Dtos
{
    public class UsuarioLoginDto
    {
        public int IdUsuario { get; set; } // Si lo necesitas para editar
        public string Nombre { get; set; } = string.Empty; // Si lo necesitas para listar/editar
        public string Email { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public bool Activo { get; set; } // Si lo necesitas para editar
    }
}