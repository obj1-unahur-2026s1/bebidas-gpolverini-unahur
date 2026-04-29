object whisky {
    method rendimiento(cantidad) = 0.9 ** cantidad
}

object terere {
    method rendimiento(cantidad) = (0.1 * cantidad).max(1)
}

object cianuro {
    method rendimiento(cantidad) = 0
}
